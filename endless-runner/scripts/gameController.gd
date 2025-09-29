extends Node2D

class_name GameController
static var instance: GameController

@export var player: CharacterBody2D
@export var camera: Camera2D

var stump_scene = preload("res://scenes/stump.tscn")
var rock_scene = preload("res://scenes/rock.tscn")
var barrel_scene = preload("res://scenes/barrel.tscn")
var bird_scene = preload("res://scenes/bird.tscn")
var coin_scene = preload("res://scenes/coin.tscn")

var obstacles_scenes_array = [stump_scene, rock_scene, barrel_scene, bird_scene]
var spawn_timer = 0
var random_spawn_limit_time = 0
var points: int = 0

func _ready() -> void:
	# Inicializa a instância do singleton
	if instance == null:
		instance = self
	
func _process(delta: float) -> void:
	# Verifique se as referências existem antes de usá-las
	if player == null or camera == null:
		return

	# Use as variáveis em vez do atalho '$'
	camera.position.x += player.SPEED * delta
	spawn_timer += delta
	if spawn_timer > random_spawn_limit_time:
		instantiate_obstacle()
		spawn_timer = 0
		random_spawn_limit_time = randf_range(1, 3)

func instantiate_obstacle():
	# Verifique se a referência ao player existe
	if player == null:
		return

	var random_index = randi_range(0,obstacles_scenes_array.size() - 1)
	var random_scene = obstacles_scenes_array[random_index]
	var obstacle_obj = random_scene.instantiate()
	var coin_obj = coin_scene.instantiate()
	
	# Use a variável 'player' aqui também
	var spawn_pos_x = player.position.x + 1100
	
	if random_scene == bird_scene:
		var obstacle_height = 68.0
		obstacle_obj.position = Vector2(spawn_pos_x, 525 - obstacle_height)
		coin_obj.position = Vector2(spawn_pos_x, 525 - obstacle_height + 68)
	else:
		var obstacle_height = obstacle_obj.get_node("Sprite2D").texture.get_height()
		obstacle_obj.position = Vector2(spawn_pos_x, 525 + obstacle_height/2)
		coin_obj.position = Vector2(spawn_pos_x, 525 - obstacle_height - 68)
	
	add_child(obstacle_obj)
	add_child(coin_obj)
