extends Control


# --- Variáveis para o código secreto ---

# A sequência de teclas que queremos detectar
const SECRET_CODE = [KEY_UP, KEY_UP, KEY_DOWN, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_LEFT, KEY_RIGHT, KEY_B, KEY_A]

# Variável para acompanhar o progresso
var current_code_index = 0

# Referência ao botão secreto (verifique se o caminho está correto!)
@onready var secret_button = $VBoxContainer/Button3


# --- Funções de botão existentes ---

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://How_to_play.tscn")

func _on_secret_pressed() -> void:
	get_tree().change_scene_to_file("res://secret_pong.tscn")

func _input(event):
	# Verifica se é um evento de tecla pressionada
	if event is InputEventKey and event.pressed:
		
		# Compara a tecla pressionada com a tecla esperada na sequência
		if event.keycode == SECRET_CODE[current_code_index]:
			# Se acertou, avança na sequência
			current_code_index += 1
		else:
			# Se errou, reinicia
			current_code_index = 0
			
		# Verifica se a sequência foi completada
		if current_code_index == SECRET_CODE.size():
			print("Código secreto ativado!")
			
			# Mostra o botão secreto
			secret_button.visible = true
			
			# Reinicia para evitar reativação
			current_code_index = 0
