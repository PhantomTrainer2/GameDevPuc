extends CharacterBody2D


@export var inventory: Array[InventorySlot]
@export var inventoryTileMap: TileMapLayer
@export var spritesheet: AnimatedSprite2D
@export var lifepoints = 3
@export var score = 0

var bullet_scene = preload("res://scenes/bullet.tscn")

var selected_item = null
var direction_x = 0
var direction_y = 0
var cooldown_time = 1.5
var cooldown_timeG = 0.5
var last_direction: Vector2 = Vector2(1,0)
const SPEED = 100.0
var life_label
var score_label


func _ready():
	life_label = get_tree().get_root().get_node("Node2D/Life")
	score_label = get_tree().get_root().get_node("Node2D/Score")

	life_label.text = "Vidas: %d" % lifepoints
	score_label.text = "Pontos: %d" % score
	
	for i in range(inventory.size()):
		var slot = inventory[i]
		var slot_sprite = Sprite2D.new()
		if slot:
			slot_sprite.texture = slot.item.sprite
			slot_sprite.position.y = 8
			slot_sprite.position.x = 16 * i + 7
			inventoryTileMap.add_child(slot_sprite)

func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo: # Check for a new key press, not a held-down echo
			if event.keycode == KEY_1:
				selected_item = inventory[0].item
			elif event.keycode == KEY_2:
				selected_item = inventory[1].item
			elif event.keycode == KEY_3:
				selected_item = inventory[2].item
			elif event.keycode == KEY_R:
				get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
			elif event.keycode == KEY_SPACE and selected_item:
				var bullet_obj = bullet_scene.instantiate()
				var sprite = bullet_obj.get_node("Sprite2D")
				sprite.texture = selected_item.sprite
				bullet_obj.position = position
				if direction_x != 0 or direction_y != 0:
					bullet_obj.direction = Vector2(direction_x, direction_y)
				else:
					bullet_obj.direction = Vector2(last_direction.x, last_direction.y)
				if selected_item.item_name == "Egg":
					bullet_obj.SPEED = 300
					if cooldown_time > 1.5:
						get_parent().add_child(bullet_obj)
						cooldown_time = 0 
				elif selected_item.item_name == "grape":
					bullet_obj.SPEED = 100
					if cooldown_timeG > 0.5:
						get_parent().add_child(bullet_obj)
						cooldown_timeG = 0 
				
				
	# Adicione esta função em qualquer lugar dentro do script do player
func take_damage(amount):
	lifepoints -= amount
	life_label.text = "Vidas: %d" % lifepoints
	print("Player tomou dano! Vidas restantes: ", lifepoints) # Opcional: para debug

	if lifepoints <= 0:
		get_tree().change_scene_to_file("res://scenes/node_2d.tscn")

func _physics_process(delta: float) -> void:
	
	cooldown_time += delta
	cooldown_timeG += delta
	if self.position.x > 750:
		self.position.x = 750
	elif self.position.x < 350:
		self.position.x = 350
	elif self.position.y < 150:
		self.position.y = 150
	elif self.position.y > 500:
		self.position.y = 500
	direction_x = Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * SPEED
		if velocity.x > 0:
			spritesheet.animation = "walking_right"
		else:
			spritesheet.animation = "walking_left"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * SPEED
		if velocity.y > 0 and not direction_x:
			spritesheet.animation = "walking_down"
		elif velocity.y < 0 and not direction_x:
			spritesheet.animation = "walking_up"
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if not direction_x and not direction_y:
		spritesheet.animation = "idle"
	
	if direction_x != 0 or direction_y != 0:
		last_direction = Vector2(direction_x, direction_y)
		
	if lifepoints <= 0:
		get_tree().change_scene_to_file("res://scenes/node_2d.tscn")

	move_and_slide()
