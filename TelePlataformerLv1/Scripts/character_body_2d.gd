extends CharacterBody2D

var usedDJ = false
var direction_x = 0
var last_direction: Vector2 = Vector2(1, 0)
var current_bullet: Area2D = null  # 🔹 guarda o projétil atual

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var spritesheet: AnimatedSprite2D
var bullet_scene = preload("res://Scenes/bullet.tscn")

func restart_level() -> void:
	var gc = GameController.get_instance()
	gc.points = 0
	get_tree().change_scene_to_file("res://Scenes/level_%d.tscn" % gc.current_level)


func _physics_process(delta: float) -> void:
	direction_x = Input.get_axis("ui_left", "ui_right")

	# --- Troca de nível ---
	if GameController.get_instance().points >= 10:
		if GameController.get_instance().current_level == 4:
			GameController.get_instance().points = 0
			get_tree().change_scene_to_file("res://Scenes/end.tscn")
		else:
			GameController.get_instance().current_level += 1
			GameController.get_instance().points = 0
			get_tree().change_scene_to_file("res://Scenes/level_%d.tscn" % GameController.get_instance().current_level)

	# --- Controle de pulo e gravidade ---
	if is_on_floor():
		usedDJ = false

	if not is_on_floor():
		if Input.is_action_just_pressed("ui_accept") and !usedDJ:
			velocity.y = JUMP_VELOCITY
			usedDJ = true
		velocity += get_gravity() * delta
		if velocity.y < 0:
			if !usedDJ:
				spritesheet.animation = "jump"
			else:
				spritesheet.animation = "dj"
		else:
			spritesheet.animation = "fall"

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# --- 🔫 Disparo (permitir 1 projétil por vez) ---
	if Input.is_action_just_pressed("shoot") and current_bullet == null:
		var bullet_obj = bullet_scene.instantiate()
		
		var sprite = bullet_obj.get_node("Sprite2D")
		if last_direction.x > 0:
			bullet_obj.position.x = position.x + 30
		else:
			bullet_obj.position.x = position.x - 30
		bullet_obj.position.y = position.y - 10
		bullet_obj.direction = Vector2(last_direction.x, 0)
		bullet_obj.SPEED = 500

		bullet_obj.player = self  
		bullet_obj.connect("bullet_freed", Callable(self, "_on_bullet_freed"))

		current_bullet = bullet_obj  # salva referência
		get_parent().add_child(bullet_obj)

	# --- Reiniciar fase ---
	if Input.is_action_just_pressed("restart"):
		restart_level()

	# --- Morte ao cair ---
	if self.position.y >= 1000:
		restart_level()

	# --- Movimento horizontal e animações ---
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		spritesheet.flip_h = direction < 0
		velocity.x = direction * SPEED
		if is_on_floor():
			spritesheet.animation = "walking"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			spritesheet.animation = "idle"

	# guarda a última direção
	if direction_x != 0:
		last_direction = Vector2(direction_x, 0)

	move_and_slide()


# --- Colisão com inimigos ---
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		restart_level()
	if area.is_in_group("BossChase"):
		restart_level()


# --- 🔹 Chamado quando o projétil é destruído ---
func _on_bullet_freed() -> void:
	current_bullet = null
