extends Area2D

@export var direction: Vector2
const SPEED = 400.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	position.x += direction.x * SPEED * delta
	position.y += direction.y * SPEED * delta
	if position.x < 0 or position.y < 0 or position.x > get_viewport().size.x or position.y > get_viewport().size.y:
		queue_free()
