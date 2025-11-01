extends Node

class_name GameController
static var instance: GameController

var points: int = 0
var current_level: int = 1

func _ready() -> void:
	instance = self

static func get_instance() -> GameController:
	return instance
