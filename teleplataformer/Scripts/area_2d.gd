extends Area2D

@export var PointsUI: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	GameController.get_instance().points += 1
	PointsUI.text = "Coins: " + str(GameController.get_instance().points)
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		GameController.get_instance().points += 1
		PointsUI.text = "Coins: " + str(GameController.get_instance().points)
		queue_free()
