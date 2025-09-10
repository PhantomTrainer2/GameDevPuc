extends RigidBody2D

var direction_Y = 0
var direction_X = 0
var speed = 200.0

func _ready() -> void:
	speed = 200.0
	self.position.x = get_window().size.x /2
	self.position.y = get_window().size.y /2
	direction_Y = randf_range(-1, 1) 
	direction_X = randi_range(-1, 1)
	if (direction_X == 0):
		direction_X = 1
	if (direction_Y == 0):
		direction_Y = -0.6
	

func _physics_process(delta: float) -> void:
	randomize()
	var velocity = Vector2(-speed * direction_X, speed * direction_Y) * delta
	var collision = move_and_collide(velocity)
	if collision:
		speed = speed + 30
		var collider = collision.get_collider()
		if collider is CharacterBody2D:
			# inverte X sempre
			direction_X *= -1
			
			# ajusta o Y dependendo do movimento do player
			if collider.movement_dir != 0:
				direction_Y += 0.5 * collider.movement_dir
			
			# normaliza vetor para não ficar muito rápido em Y
			var dir = Vector2(direction_X, direction_Y).normalized()
			direction_X = dir.x
			direction_Y = dir.y
	else:
		self.position += velocity

	# Pontuação
	if (GameController.player1_score >= GameController.score_limit -1 or GameController.player2_score >= GameController.score_limit - 1):
		GameController.end_game()
		
	if (self.position.x >= 1200):
		GameController.player1_score += 1
		_ready()
	if (self.position.x <= 0):
		GameController.player2_score += 1
		_ready()


	# Colisão no topo/baixo da tela
	if (self.position.y <= 0):
		self.position.y = 0
		direction_Y *= -1
	if (self.position.y >= get_window().size.y):
		self.position.y = get_window().size.y
		direction_Y *= -1
