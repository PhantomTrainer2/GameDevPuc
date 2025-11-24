extends Area2D

@export var speed: float = 400.0

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(body: Node) -> void:
	# Colidiu com o chão
	if body.is_in_group("chao"):
		queue_free()
	# Colidiu com o jogador
	elif body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/level_4.tscn")

func _on_area_entered(area: Area2D) -> void:
	# Caso seu chão ou player sejam Areas, tratamos aqui também
	if area.is_in_group("chao"):
		queue_free()
	elif area.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/level_4.tscn")
