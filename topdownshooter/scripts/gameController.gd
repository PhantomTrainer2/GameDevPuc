extends Node2D

# Adicione estas linhas ao seu script principal (o que está no Node2D)

# --- INÍCIO DA LÓGICA DO SPAWNER ---

# Variáveis para guardar as cenas dos inimigos e os nós que criamos
var enemy_scenes = []
@onready var enemy_timer = $enemyTimer
@onready var spawn_points_container = $SpawnPoints


# Dentro da sua função _ready(), adicione estas linhas:
func _ready():
	
	enemy_scenes.append(preload("res://scenes/enemy.tscn"))
	enemy_scenes.append(preload("res://scenes/enemy_2.tscn"))
	
	# Inicia o ciclo de spawn
	start_spawn_timer()


# Adicione estas duas novas funções ao seu script:

func start_spawn_timer():
	# Define um tempo de espera aleatório entre 0.5 e 2.0 segundos
	var random_wait_time = randf_range(0.5, 2.0)
	enemy_timer.wait_time = random_wait_time
	enemy_timer.start()


func _on_enemy_timer_timeout():
	# Verifica se há cenas de inimigos e pontos de spawn para evitar erros
	if enemy_scenes.is_empty() or spawn_points_container.get_child_count() == 0:
		return

	# Escolhe uma cena de inimigo aleatória do array
	var random_enemy_scene = enemy_scenes.pick_random()

	# Escolhe um ponto de spawn aleatório
	var spawn_points = spawn_points_container.get_children()
	var random_spawn_point = spawn_points.pick_random()

	# Cria (instancia) o inimigo
	var new_enemy = random_enemy_scene.instantiate()

	add_child(new_enemy)
	new_enemy.global_position = random_spawn_point.global_position

	start_spawn_timer()
