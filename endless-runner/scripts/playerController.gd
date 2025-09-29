extends CharacterBody2D

var standing_shape = preload("res://assets/RunningHitbox.tres")
var crouching_shape = preload("res://assets/CrouchingHitbox.tres")

@onready var collision_shape = $CollisionShape2D

var SPEED = 300.0
const JUMP_VELOCITY = -550.0
@export var spritesheet: AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("down"):
		spritesheet.play("crouching")
		collision_shape.shape = crouching_shape
		velocity.y += 20
	else:
		spritesheet.play("running")
		collision_shape.shape = standing_shape
		
	velocity.x = SPEED
	move_and_slide()
