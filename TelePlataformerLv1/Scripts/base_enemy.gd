extends Area2D

@export var speed: float = 60.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_ray: RayCast2D = $RayCast2D

var direction: int = 1  # 1 = direita, -1 = esquerda
var base_offset_x: float = 0.0

func _ready() -> void:
	# Guarda o offset original do RayCast (configurado no editor)
	base_offset_x = floor_ray.position.x

	direction = 1
	floor_ray.enabled = true

	if sprite:
		sprite.play("walk")  # nome da animação de andar
		sprite.flip_h = false


func _process(delta: float) -> void:
	# Mantém o RayCast sempre na "frente" do inimigo
	floor_ray.position.x = base_offset_x * direction

	# 1) Checa o chão à frente ANTES de mover
	if not floor_ray.is_colliding():
		_flip()
		# Depois de virar, o ray passa a olhar pro outro lado
		floor_ray.position.x = base_offset_x * direction
		return  # não anda nesse frame, evita flip infinito

	# 2) Se tem chão na frente, anda
	position.x += speed * direction * delta


func _flip() -> void:
	direction *= -1

	if sprite:
		sprite.flip_h = (direction == -1)
