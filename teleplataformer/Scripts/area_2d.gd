extends Area2D

@export var bob_amplitude: float = 6.0   # quanto sobe/desce (pixels)
@export var bob_speed: float = 2.0       # velocidade da oscilação
@export var desync_phase: bool = true    # desincronizar quando houver várias chaves

var _base_pos: Vector2
var _t: float = 0.0
var _phase: float = 0.0

func _ready() -> void:
	_base_pos = position
	if desync_phase:
		var rng := RandomNumberGenerator.new()
		rng.randomize()
		_phase = rng.randf_range(0.0, TAU) # TAU = 2*PI

func _process(delta: float) -> void:
	_t += delta
	# mantém X, só oscila no Y
	position.y = _base_pos.y + sin(_t * bob_speed + _phase) * bob_amplitude

func _on_body_entered(body: Node2D) -> void:
	GameController.get_instance().points += 1
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		GameController.get_instance().points += 1
		queue_free()
