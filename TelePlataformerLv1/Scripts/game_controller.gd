extends Node
class_name GameController

static var instance: GameController

var points: int = 0
var coinsCollected: int = 0
var current_level: int = 1

# variável que níveis específicos podem usar (ex: level 3 perseguição)
var reached_goal: bool = false

func _ready() -> void:
	instance = self
	# garante defaults
	points = 0
	coinsCollected = 0
	reached_goal = false

static func get_instance() -> GameController:
	return instance

# chamada quando o summary confirma 'Continuar'
func advance_level() -> void:
	# resetar contadores antes de trocar de cena (evita carryover)
	coinsCollected = 0
	points = 0
	reached_goal = false

	current_level += 1

	match current_level:
		2:
			get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
		3:
			get_tree().change_scene_to_file("res://Scenes/level_3.tscn")
		4:
			get_tree().change_scene_to_file("res://Scenes/level_4.tscn")
		5:
			get_tree().change_scene_to_file("res://Scenes/end.tscn")
		_:
			push_error("Nível desconhecido: %d" % current_level)

# Função centralizada que decide se o level pode ser finalizado
func can_finish_level() -> bool:
	match current_level:
		1, 2:
			# por exemplo: requer ter pontos (chave)
			return points > 0
		3:
			# level 3 é perseguição: só termina quando a flag reached_goal for true
			return reached_goal or points > 0
		_:
			return false
