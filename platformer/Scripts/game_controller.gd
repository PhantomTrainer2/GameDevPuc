extends Node2D

class_name GameController
static var _instance: GameController = null

var points = 0

static func get_instance() -> GameController:
	if _instance == null:
		_instance = GameController.new()
	return _instance
