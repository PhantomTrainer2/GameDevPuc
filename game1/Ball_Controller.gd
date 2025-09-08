extends RigidBody2D

var direction_Y = 0
var direction_X = 0
var player1_score = 0
var player2_score = 0

func _init() -> void:
	self.position.x = 640
	self.position.y =  360
	direction_Y = randf_range(-1, 1) 
	direction_X = randi_range(-1, 1)
	if (direction_X == 0):
		direction_X = 1
	if (direction_Y == 0):
		direction_Y = -1

func _physics_process(delta: float) -> void:
	randomize()
	
	self.position.x -= 200 * direction_X * delta
	self.position.y += 200 * direction_Y * delta
	if (self.position.x >= 1200):
		player1_score += 1
		_init()
	if (self.position.x <= 0):
		player2_score += 1
		_init()
		
	#var collision = move_and_collide(200 * delta)
	#if (collision):
		#direction_x *= -1
	
