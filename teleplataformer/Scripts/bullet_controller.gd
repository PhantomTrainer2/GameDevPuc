extends Area2D

signal bullet_freed

@export var direction: Vector2
@export var SPEED = 500.0
@export var start_gravity: float = 200.0  # intensidade base
@export var gravity_scale: float = 4.0  # fator de ajuste
var time_in_air: float = 0.0

var velocity: Vector2
var player: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = direction * SPEED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	time_in_air += delta
	
	var gravity_force = start_gravity * time_in_air * gravity_scale
	
	velocity.y += gravity_force * delta
	position += velocity * delta
	
	if position.y >= 1000:
		queue_free()


func _on_tree_exited() -> void:
	emit_signal("bullet_freed")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("chao"):
		if player != null:
			player.position = self.position
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.queue_free()
		queue_free()
