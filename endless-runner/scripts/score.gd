extends Control

@onready var final_score_label = $CanvasLayer/FinalScore

func _ready():
	final_score_label.text = "Final Score: " + str(Controller.points)

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
