extends Node2D

var stump_scene = preload("res://scenes/stump.tscn")
var rock_scene = preload("res://scenes/rock.tscn")
var barrel_scene = preload("res://scenes/barrel.tscn")

var obstacles_scenes_array = [stump_scene, rock_scene, barrel_scene]

var spawn_timer = 0

var random_spawn_limit_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera2D.position.x += $CharacterBody2D.SPEED * delta
	spawn_timer += delta
	if spawn_timer > random_spawn_limit_time:
		instantiate_obstacle()
		spawn_timer = 0
		random_spawn_limit_time = randf_range(1, 3)

func instantiate_obstacle():
	var random_index = randi_range(0,obstacles_scenes_array.size() - 1)
	var random_scene = obstacles_scenes_array[random_index]
	var obstacle_obj = random_scene.instantiate()
	var obstacle_height = obstacle_obj.get_node("Sprite2D").texture.get_height()
	
	obstacle_obj.position = Vector2($CharacterBody2D.position.x + 1100, 525 + obstacle_height/2)
	
	add_child(obstacle_obj)
