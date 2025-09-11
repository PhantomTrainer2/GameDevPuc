extends Control

const SECRET_CODE = [KEY_UP, KEY_UP, KEY_DOWN, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_LEFT, KEY_RIGHT, KEY_B, KEY_A]

var current_code_index = 0

@onready var secret_button = $VBoxContainer/Button3

@onready var secret_sound = $secretActivation


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://How_to_play.tscn")

func _on_secret_pressed() -> void:
	get_tree().change_scene_to_file("res://secret_pong.tscn")

func _input(event):
	if event is InputEventKey and event.pressed:
		
		if event.keycode == SECRET_CODE[current_code_index]:
			current_code_index += 1
		else:
			current_code_index = 0
			
		if current_code_index == SECRET_CODE.size():
			print("Código secreto ativado!")
			
			secret_button.visible = true
			
			secret_sound.play()
			
			current_code_index = 0
