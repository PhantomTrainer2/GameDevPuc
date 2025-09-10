extends CharacterBody2D

var speed = 300

func _process(delta: float) -> void:
	if Input.is_action_pressed("down_player1"):
		self.position.y += speed * delta
	if Input.is_action_pressed("up_player1"):
		self.position.y -= speed * delta
	if (self.position.y - 60 <= 0):
		self.position.y = 60
	if (self.position.y + 60 >= 648):
		self.position.y = 588
