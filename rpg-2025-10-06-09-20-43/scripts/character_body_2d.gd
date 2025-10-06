extends CharacterBody2D


@export var inventory: Array[InventorySlot]
@export var inventoryTileMap: TileMapLayer

var bullet_scene = preload("res://scenes/bullet.tscn")

var selectedItem = null
const SPEED = 100.0

var direction_x = 0
var direction_y = 0
var last_direction: Vector2 = Vector2(1,0)
var cooldown_time = 3

func _ready():
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
		if event.pressed and not event.echo:
			if event.keycode == KEY_1:
				selectedItem = inventory[0].item
			elif event.keycode == KEY_2:
				if inventory[1] != null:
					selectedItem = inventory[1].item
			elif event.keycode == KEY_3:
				selectedItem = inventory[2].item
			elif event.keycode == KEY_R:
				get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
			elif event.keycode == KEY_SPACE:
				if selectedItem == null:
					pass
				else:
					var bullet_obj = bullet_scene.instantiate()
					var sprite = bullet_obj.get_node("Sprite2D")
					sprite.texture = selectedItem.sprite
					bullet_obj.position = position
					if direction_x != 0 or direction_y != 0:
						bullet_obj.direction = Vector2(direction_x, direction_y)
					else:
						bullet_obj.direction = Vector2(last_direction.x, last_direction.y)
					if cooldown_time > 2:
						get_parent().add_child(bullet_obj)
						cooldown_time = 0

func _physics_process(delta: float) -> void:
	cooldown_time += delta
	direction_x = Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if direction_x != 0 or direction_y != 0:
		last_direction = Vector2(direction_x, direction_y)
	move_and_slide()
