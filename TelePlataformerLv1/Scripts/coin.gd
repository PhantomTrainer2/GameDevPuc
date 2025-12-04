extends Area2D

@export var bob_amplitude: float = 6.0
@export var bob_speed: float = 2.0
@export var desync_phase: bool = true

var _base_pos: Vector2
var _t: float = 0.0
var _phase: float = 0.0

var _collected: bool = false

func _ready() -> void:
	_base_pos = position
	if desync_phase:
		var rng := RandomNumberGenerator.new()
		rng.randomize()
		_phase = rng.randf_range(0.0, TAU)

func _process(delta: float) -> void:
	_t += delta
	position.y = _base_pos.y + sin(_t * bob_speed + _phase) * bob_amplitude

func _collect() -> void:
	if _collected:
		return
	_collected = true

	var gc = GameController.get_instance()
	if gc != null:
		gc.coinsCollected += 1
		print("coin collected -> coinsCollected =", gc.coinsCollected)

	# desativa colisões imediatamente para evitar triggers adicionais
	set_monitoring(false)
	set_process(false)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	# opcional: só aceitar pickup por player
	if not body.is_in_group("player"):
		return
	_collect()

func _on_area_entered(area: Area2D) -> void:
	# exemplo: se um "bullet" pode coletar, trate aqui; caso contrário ignore
	if area.is_in_group("bullet"):
		_collect()
