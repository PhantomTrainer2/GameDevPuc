extends CharacterBody2D

var speed = 300
var movement_dir = 0  # -1 = cima, 1 = baixo, 0 = parado

func _process(delta: float) -> void:
	movement_dir = 0
	if Input.is_action_pressed("down_player1"):
		self.position.y += speed * delta
		movement_dir = 1
	if Input.is_action_pressed("up_player1"):
		self.position.y -= speed * delta
		movement_dir = -1

	if (self.position.y - 60 <= 0):
		self.position.y = 60
	if (self.position.y + 60 >= get_window().size.y):
		self.position.y = 588
