# Script para um inimigo do tipo Area2D que se move
extends Area2D

const SPEED = 90.0

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if not player:
		return

	# Calcula a direção e move a Area2D manualmente
	var direction = (player.global_position - self.global_position).normalized()
	global_position += direction * SPEED * delta

# O sinal "body_entered" funciona exatamente como antes.
# Apenas certifique-se de conectá-lo a esta função no editor.
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(1)
		position.x -= 30
		position.y -= 30


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		area.queue_free()
		queue_free()
		
