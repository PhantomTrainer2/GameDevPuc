extends Node

@export var snake_scene : PackedScene

var score : int
var game_started : bool = false
var high_score : int = 0 
var high_score_file_path = "user://highscore.txt" 

var cells : int = 20
var cell_size : int = 50

var food_pos : Vector2
var regen_food : bool = true
var current_food_type : String = "apple" 

@onready var apple = $Food
@onready var grape = $Grape
@onready var pause_menu = $PauseMenu 
@onready var result_label = $GameOverMenu/ResultLabel 

@onready var power_up = $PowerUp 		
@onready var power_down = $PowerDown 	
var power_timer : Timer 
var current_power_type : String = "" 
var power_pos : Vector2
var power_active : bool = false 

var power_up_effect_timer : Timer   
var power_down_effect_timer : Timer 
var score_multiplier_active : bool = false
var original_move_speed : float 

var power_despawn_timer : Timer 

const POWER_EFFECT_DURATION = 10.0 
const POWER_DESPAWN_DURATION = 5.0 
const POWER_DOWN_SLOW_FACTOR = 2.5 

var old_data : Array = []
var snake_data : Array = []
var snake : Array = []

var start_pos = Vector2(9, 9)
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var left = Vector2(-1, 0)
var right = Vector2(1, 0)
var move_direction : Vector2
var can_move : bool

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	
	power_timer = Timer.new()
	power_timer.wait_time = 15.0
	power_timer.one_shot = false   
	power_timer.timeout.connect(_on_power_timer_timeout) 
	add_child(power_timer) 
	
	power_up_effect_timer = Timer.new()
	power_up_effect_timer.wait_time = POWER_EFFECT_DURATION
	power_up_effect_timer.one_shot = true 
	power_up_effect_timer.timeout.connect(_on_power_up_effect_timeout) 
	add_child(power_up_effect_timer)
	
	power_down_effect_timer = Timer.new()
	power_down_effect_timer.wait_time = POWER_EFFECT_DURATION
	power_down_effect_timer.one_shot = true 
	power_down_effect_timer.timeout.connect(_on_power_down_effect_timeout) 
	add_child(power_down_effect_timer)

	power_despawn_timer = Timer.new()
	power_despawn_timer.wait_time = POWER_DESPAWN_DURATION
	power_despawn_timer.one_shot = true 
	power_despawn_timer.timeout.connect(_on_power_despawn_timeout) 
	add_child(power_despawn_timer)
	
	original_move_speed = $MoveTimer.wait_time
	
	load_highscore() 
	new_game()
	
func new_game():
	get_tree().paused = false
	get_tree().call_group("segments", "queue_free")
	
	power_timer.stop() 
	power_up_effect_timer.stop()
	power_down_effect_timer.stop()
	power_despawn_timer.stop() 
	$MoveTimer.wait_time = original_move_speed 
	
	$GameOverMenu.hide()
	pause_menu.hide() 
	
	power_up.hide()
	power_down.hide()
	power_active = false
	current_power_type = ""
	score_multiplier_active = false 
	
	score = 0
	$Hud.get_node("ScoreLabel").text = "SCORE: " + str(score)
	move_direction = up
	can_move = true
	generate_snake()
	move_food()
	
func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	for i in range(3):
		add_segment(start_pos + Vector2(0, i))
		
func add_segment(pos):
	snake_data.append(pos)
	var SnakeSegment = snake_scene.instantiate()
	SnakeSegment.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(SnakeSegment)
	snake.append(SnakeSegment)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and game_started:
		if get_tree().is_paused():
			if pause_menu.visible:
				unpause_game()
		else:
			pause_game()
			
	if get_tree().is_paused():
		return 
			
	move_snake()
	
func move_snake():
	if can_move:
		if Input.is_action_just_pressed("move_down") and move_direction != up:
			move_direction = down
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_up") and move_direction != down:
			move_direction = up
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_left") and move_direction != right:
			move_direction = left
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_right") and move_direction != left:
			move_direction = right
			can_move = false
			if not game_started:
				start_game()

func start_game():
	game_started = true
	$MoveTimer.start()
	power_timer.start() 

func _on_move_timer_timeout():
	can_move = true
	old_data = [] + snake_data
	snake_data[0] += move_direction
	for i in range(len(snake_data)):
		if i > 0:
			snake_data[i] = old_data[i - 1]
		snake[i].position = (snake_data[i] * cell_size) + Vector2(0, cell_size)
	check_out_of_bounds()
	check_self_eaten()
	check_food_eaten()
	check_power_eaten() 
	
func check_out_of_bounds():
	if snake_data[0].x < 0 or snake_data[0].x > cells - 1 or snake_data[0].y < 0 or snake_data[0].y > cells - 1:
		end_game()
		
func check_self_eaten():
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			end_game()
			
func check_food_eaten():
	if snake_data[0] == food_pos:
		if score_multiplier_active:
			if current_food_type == "apple":
				score += 2 
			elif current_food_type == "grape":
				score += 10 
		else:
			if current_food_type == "apple":
				score += 1
			elif current_food_type == "grape":
				score += 5
		
		$Hud.get_node("ScoreLabel").text = "SCORE: " + str(score)
		add_segment(old_data[-1])
		move_food()
	
func move_food():
	while regen_food:
		regen_food = false
		var chance = randf() 
		if chance <= 0.8:
			current_food_type = "apple"
		else:
			current_food_type = "grape"

		food_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells - 1))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	
	if current_food_type == "apple":
		apple.show()
		grape.hide()
		apple.position = (food_pos * cell_size) + Vector2(0, cell_size)
	else:
		grape.show()
		apple.hide()
		grape.position = (food_pos * cell_size) + Vector2(0, cell_size)

	regen_food = true

func end_game():
	$MoveTimer.stop()
	power_timer.stop() 
	power_up_effect_timer.stop() 
	power_down_effect_timer.stop()
	power_despawn_timer.stop() 
	game_started = false
	
	if score > high_score:
		high_score = score
		save_highscore()
		
	result_label.text = "SCORE: " + str(score) + "\nHIGH SCORE: " + str(high_score)
	
	$GameOverMenu.show()
	get_tree().paused = true


func _on_game_over_menu_restart():
	new_game()

func pause_game():
	get_tree().paused = true
	$MoveTimer.stop() 
	power_timer.stop() 
	
	power_up_effect_timer.paused = true
	power_down_effect_timer.paused = true
	power_despawn_timer.paused = true 
	
	pause_menu.show()

func unpause_game():
	get_tree().paused = false
	pause_menu.hide()
	$MoveTimer.start() 
	power_timer.start() 
	
	power_up_effect_timer.paused = false
	power_down_effect_timer.paused = false
	power_despawn_timer.paused = false 

func load_highscore():
	if FileAccess.file_exists(high_score_file_path):
		var file = FileAccess.open(high_score_file_path, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			if content.is_valid_int():
				high_score = int(content)
			file.close()
	else:
		high_score = 0

func save_highscore():
	var file = FileAccess.open(high_score_file_path, FileAccess.WRITE)
	if file:
		file.store_string(str(high_score))
		file.close()

func _on_power_timer_timeout():
	if power_active:
		return

	if randf() > 0.5:
		current_power_type = "up"
	else:
		current_power_type = "down"

	var regen_power_pos = true
	while regen_power_pos:
		regen_power_pos = false
		power_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells - 1))
		
		for i in snake_data:
			if power_pos == i:
				regen_power_pos = true
				break 
		
		if regen_power_pos:
			continue 
			
		if power_pos == food_pos:
			regen_power_pos = true
			continue
	
	if current_power_type == "up":
		power_up.show()
		power_up.position = (power_pos * cell_size) + Vector2(0, cell_size)
	else: 
		power_down.show()
		power_down.position = (power_pos * cell_size) + Vector2(0, cell_size)

	power_active = true
	power_despawn_timer.start() 

func check_power_eaten():
	if not power_active:
		return

	if snake_data[0] == power_pos:
		power_despawn_timer.stop() 
		
		power_up.hide()
		power_down.hide()
		
		if current_power_type == "up":
			score_multiplier_active = true
			power_up_effect_timer.start() 
			
		elif current_power_type == "down":
			if $MoveTimer.wait_time == original_move_speed:
				$MoveTimer.wait_time = original_move_speed * POWER_DOWN_SLOW_FACTOR
			
			power_down_effect_timer.start() 
		
		power_active = false
		current_power_type = ""

func _on_power_up_effect_timeout():
	score_multiplier_active = false

func _on_power_down_effect_timeout():
	$MoveTimer.wait_time = original_move_speed

func _on_power_despawn_timeout():
	if not power_active:
		return
		
	power_up.hide()
	power_down.hide()
	
	power_active = false
	current_power_type = ""
	
	power_timer.start()
