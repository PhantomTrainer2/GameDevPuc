extends Area2D

# caminho para a cena de resumo
const SUMMARY_SCENE := "res://Scenes/summary.tscn"

# proteção: pequena demora antes de aceitar triggers (evita gatilhos no spawn)
@export var enable_delay: float = 0.15
var _enabled: bool = false

func _ready() -> void:
	# habilita após um curtíssimo delay para evitar triggers por colisores posicionais
	_enabled = false
	# cria timer sem bloquear
	var t = get_tree().create_timer(enable_delay)
	t.timeout.connect(Callable(self, "_on_enable_timeout"))

func _on_enable_timeout() -> void:
	_enabled = true

func _on_body_entered(body: Node2D) -> void:
	# debug - descomente pra ver o que está batendo
	#print("door: body entered ->", body, " name=", body.name, " groups=", body.get_groups())

	# não processe se ainda não habilitado (evita triggers na criação)
	if not _enabled:
		return

	# só o player pode acionar a porta
	if not body.is_in_group("player"):
		return

	var gc = GameController.get_instance()
	if gc == null:
		push_warning("GameController não encontrado em door.gd")
		return

	# usa a função centralizada para saber se o nível pode terminar
	if not gc.can_finish_level():
		# opcional: debug
		#print("door: can_finish_level() == false for level", gc.current_level, "points=", gc.points, "reached_goal=", gc.reached_goal)
		return

	# instancia e mostra o summary
	var summary_scene = load(SUMMARY_SCENE)
	var summary = summary_scene.instantiate()
	# adiciona ao root primeiro para garantir _ready() do summary já ter rodado
	get_tree().get_root().add_child(summary)

	# passa as moedas coletadas (agora após add_child para garantir que summary._ready() já rodou)
	if summary.has_method("set_coins"):
		summary.set_coins(gc.coinsCollected)
	else:
		push_warning("summary não tem método set_coins()")

	# opcional: pausar o jogo enquanto o summary está visível
	# get_tree().paused = true

	# opcional: prevenir re-trigger
	set_monitoring(false)
	queue_free()
