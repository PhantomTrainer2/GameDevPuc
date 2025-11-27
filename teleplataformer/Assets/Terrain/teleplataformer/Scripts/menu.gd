extends Control


var current_code_index = 0

@onready var secret_button = $VBoxContainer/Button3

@onready var secret_sound = $secretActivation


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
