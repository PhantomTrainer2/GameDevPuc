extends Area2D

@export var arrow_scene: PackedScene = preload("res://Scenes/arrow.tscn")
@export var shoot_interval: float = 3.0  # segundos entre tiros
@export var move_speed: float = 100.0    # velocidade no eixo X

@export var max_hp: int = 10
@export var sprite: AnimatedSprite2D     # arraste o AnimatedSprite2D do chefe aqui

var hp: int
var original_modulate: Color = Color.WHITE


func _ready() -> void:
	hp = max_hp

	if sprite:
		original_modulate = sprite.modulate

	shoot_loop()  # inicia o loop de disparo


func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var dx: float = player.global_position.x - global_position.x

	# Só anda se a distância for relevante (evita tremer em cima do player)
	if abs(dx) > 5.0:
		var dir_x: float = sign(dx)  # -1 (esquerda) ou 1 (direita)
		global_position.x += dir_x * move_speed * delta

		# Flip do sprite para acompanhar o player
		if sprite:
			# assumindo que o sprite "normal" olha para a direita
			sprite.flip_h = dir_x > 0


# --- Loop infinito de tiros ---
func shoot_loop() -> void:
	# espera um frame pra garantir que tudo está pronto
	await get_tree().process_frame

	while true:
		shoot_at_player()
		await get_tree().create_timer(shoot_interval).timeout


func shoot_at_player() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var arrow = arrow_scene.instantiate() as Area2D

	# posição inicial da flecha = posição do boss
	arrow.global_position = global_position

	# direção do boss até o player
	var dir: Vector2 = (player.global_position - global_position).normalized()

	# configura velocidade e rotação da flecha
	arrow.velocity = dir * arrow.speed
	arrow.rotation = dir.angle()

	get_tree().current_scene.add_child(arrow)


# --- Vida / dano / morte ---
func take_damage(amount: int) -> void:
	hp -= amount
	flash_red()
	if hp <= 0:
		die()


func die() -> void:
	get_tree().change_scene_to_file("res://Scenes/end.tscn")


# Pisca vermelho rapidamente ao levar dano
func flash_red() -> void:
	if sprite == null:
		return

	sprite.modulate = Color(1, 0, 0)  # vermelho
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = original_modulate


# --- Colisão com projéteis do player ---
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		take_damage(1)
		area.queue_free()
