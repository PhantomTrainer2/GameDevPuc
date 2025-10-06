extends CharacterBody2D


@export var inventory: Array[InventorySlot]
@export var inventoryTileMap: TileMapLayer
const SPEED = 100.0

func _ready():
	for i in range(inventory.size()):
		var slot = inventory[i]
		var slot_sprite = Sprite2D.new()
		if slot:
			slot_sprite.texture = slot.item.sprite
			slot_sprite.position.y = 8
			slot_sprite.position.x = 16 * i + 7
			inventoryTileMap.add_child(slot_sprite)

func _physics_process(delta: float) -> void:
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var direction_y := Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
