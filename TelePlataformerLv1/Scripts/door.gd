extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if GameController.get_instance().points > 0:
		GameController.get_instance().current_level += 1
		GameController.get_instance().points = 0
		if GameController.get_instance().current_level  == 2:
			get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
		if GameController.get_instance().current_level  == 3:
			get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
		queue_free()
