extends CharacterBody2D
var usedDJ = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var spritesheet: AnimatedSprite2D

func restart_level() -> void:
	var gc = GameController.get_instance()
	gc.points = 0
	get_tree().change_scene_to_file("res://Scenes/level_%d.tscn" % gc.current_level)


func _physics_process(delta: float) -> void:
	if GameController.get_instance().points >= 10:
		if GameController.get_instance().current_level == 2:
			GameController.get_instance().points = 0
			get_tree().change_scene_to_file("res://Scenes/end.tscn")
		else:
			GameController.get_instance().current_level += 1
			GameController.get_instance().points = 0
			get_tree().change_scene_to_file("res://Scenes/level_2.tscn")

	if is_on_floor():
		usedDJ = false
		
	if not is_on_floor():
		if Input.is_action_just_pressed("ui_accept") and !usedDJ:
			velocity.y = JUMP_VELOCITY
			usedDJ = true
		velocity += get_gravity() * delta
		if velocity.y < 0:
			if !usedDJ:
				spritesheet.animation = "jump"
			else:
				spritesheet.animation = "dj"
		else:
			spritesheet.animation = "fall"

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("restart"):
		restart_level()
		
	if self.position.y >= 1000:
		restart_level()

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		spritesheet.flip_h = direction < 0
		velocity.x = direction * SPEED
		if (is_on_floor()):
			spritesheet.animation = "walking"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if (is_on_floor()):
			spritesheet.animation = "idle"

	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name.contains("enemy"):
		restart_level()
