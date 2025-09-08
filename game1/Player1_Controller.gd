extends CharacterBody2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("down_player1"):
		self.position.y += 100 * delta
	if Input.is_action_pressed("up_player1"):
		self.position.y -= 100 * delta
