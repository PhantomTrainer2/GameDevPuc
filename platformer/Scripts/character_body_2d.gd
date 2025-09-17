extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var spritesheet: AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0:
			spritesheet.animation = "jump"
		else:
			spritesheet.animation = "fall"

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_file("res://Scenes/main.tscn")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		spritesheet.flip_h = direction < 0
		velocity.x = direction * SPEED
		if (is_on_floor()):
			spritesheet.animation = "walking"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if (is_on_floor()):
			spritesheet.animation = "idle"

	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "enemy":
		GameController.get_instance().points = 0
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
