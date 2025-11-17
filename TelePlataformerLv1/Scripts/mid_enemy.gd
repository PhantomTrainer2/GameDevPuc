extends Area2D

@export var speed: float = 60.0                 # velocidade ao andar
@export var detection_range: float = 400.0     # até que distância ele “vê” o player (em X)
@export var same_height_tolerance: float = 30.0 # tolerância de altura pra considerar mesma linha

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_ray: RayCast2D = $RayCast2D  # ray para checar chão na frente

var player: Node2D = null
var is_chasing: bool = false
var direction: int = -1                         # -1 = esquerda, 1 = direita
var floor_ray_base_offset_x: float = 0.0        # offset original do RayCast em X


func _ready() -> void:
	# Guarda o offset original configurado no editor
	floor_ray_base_offset_x = floor_ray.position.x
	floor_ray.enabled = true

	# Começa parado olhando para a esquerda
	direction = -1
	if sprite:
		sprite.play("Idle")
		sprite.flip_h = true  # true = olhando para a esquerda (ajuste se for o contrário)

	# Procura o player pelo grupo "player"
	player = get_tree().get_first_node_in_group("player") as Node2D


func _process(delta: float) -> void:
	# Garante que temos referência válida ao player
	if player == null or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as Node2D
		return

	var to_player: Vector2 = player.global_position - global_position
	var horizontal_distance: float = abs(to_player.x)
	var vertical_distance: float = abs(to_player.y)

	# Verifica se o player está "na mesma altura" e dentro do alcance horizontal
	if vertical_distance <= same_height_tolerance and horizontal_distance <= detection_range:
		is_chasing = true
	else:
		is_chasing = false

	if is_chasing:
		_chase_player(delta, to_player)
	else:
		_stay_idle()


func _update_floor_ray_position() -> void:
	# Mantém o RayCast sempre na "frente" do inimigo, dependendo da direção
	floor_ray.position.x = floor_ray_base_offset_x * direction


func _can_move_in_direction() -> bool:
	_update_floor_ray_position()
	return floor_ray.is_colliding()


func _chase_player(delta: float, to_player: Vector2) -> void:
	# Define a direção horizontal em relação ao player (sem usar := pra evitar Variant)
	var dir_x: int = 0
	if to_player.x > 0.0:
		dir_x = 1
	elif to_player.x < 0.0:
		dir_x = -1

	if dir_x == 0:
		# Player exatamente em cima no eixo X -> fica parado
		_stay_idle()
		return

	direction = dir_x

	# Só anda se tiver chão na frente
	if not _can_move_in_direction():
		_stay_idle()
		return

	# Movimento
	global_position.x += direction * speed * delta

	# Atualiza sprite (direção + animação)
	if sprite:
		sprite.flip_h = (direction == -1)
		if sprite.animation != "walk":
			sprite.play("walk")


func _stay_idle() -> void:
	if sprite and sprite.animation != "Idle":
		sprite.play("Idle")
