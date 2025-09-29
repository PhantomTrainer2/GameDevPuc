extends Area2D

@export var PointsUI: Label

func _ready():
	PointsUI = get_node("/root/main/UI/PointsUI")
	
func _on_body_entered(body: Node2D) -> void:
	Controller.points += 1
	PointsUI.text = "Score: " + str(Controller.points)
	queue_free()
