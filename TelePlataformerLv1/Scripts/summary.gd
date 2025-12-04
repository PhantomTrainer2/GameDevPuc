extends Node2D
# se preferir, troque para CanvasLayer: extends CanvasLayer

@export var total_coins: int = 10
var coins: int = 0

var coins_label: Label = null
var continue_btn: Button = null
var panel: Node = null
var _ready_ran: bool = false

func _ready() -> void:
	# 1) tenta caminhos absolutos que cobrem seu layout conforme a imagem
	if has_node("Label"):
		coins_label = $Label
	elif has_node("CoinsLabel"):
		coins_label = $CoinsLabel
	elif has_node("Panel/CenterContainer/MarginContainer/VBoxContainer/CoinsLabel"):
		coins_label = $Panel/CenterContainer/MarginContainer/VBoxContainer/CoinsLabel
	elif has_node("Panel/CenterContainer/MarginContainer/VBoxContainer/Label"):
		coins_label = $Panel/CenterContainer/MarginContainer/VBoxContainer/Label
	else:
		# fallback recursivo
		coins_label = _find_node_by_any_name(self, ["CoinsLabel", "Label"])

	# botão: seu botão está em Control/VBoxContainer/Button na imagem
	if has_node("Control/VBoxContainer/Button"):
		continue_btn = $Control/VBoxContainer/Button
	elif has_node("Control/VBoxContainer/ContinueButton"):
		continue_btn = $Control/VBoxContainer/ContinueButton
	else:
		continue_btn = _find_node_by_any_name(self, ["ContinueButton", "Button"])

	# painel (opcional)
	if has_node("Panel"):
		panel = $Panel
	elif has_node("Control"):
		panel = $Control
	else:
		panel = _find_node_by_any_name(self, ["Panel", "Control"])

	print("Summary._ready(): coins_label =", coins_label, " continue_btn =", continue_btn, " panel =", panel, " coins (stored) =", coins)

	# atualiza o label se já temos valor
	_update_label()

	# conecta o botão ao método que você pediu
	if continue_btn != null:
		if not continue_btn.is_connected("pressed", Callable(self, "_on_button_pressed")):
			continue_btn.connect("pressed", Callable(self, "_on_button_pressed"))
	else:
		push_warning("ContinueButton não encontrado — verifique nome/hierarquia na cena summary.tscn")

	# se quiser que o UI funcione com a tree pausada, descomente:
	# process_mode = Node.PROCESS_MODE_ALWAYS

	_ready_ran = true


# pode ser chamada antes ou depois do add_child
func set_coins(c: int) -> void:
	coins = c
	print("Summary.set_coins() chamado com:", coins)
	# atualiza se ready já rodou e o label existe
	if _ready_ran and coins_label != null:
		_update_label()

func _update_label() -> void:
	if coins_label != null:
		var new_text = "Você coletou %d / %d moedas" % [coins, total_coins]
		print("Summary._update_label(): setando texto ->", new_text)
		coins_label.text = new_text
	else:
		push_warning("CoinsLabel não encontrado no _update_label(); valor guardado (coins=%d)" % coins)

func _on_button_pressed() -> void:
	# despausa se necessário
	if get_tree().paused:
		get_tree().paused = false

	var gc = GameController.get_instance()
	if gc != null:
		gc.advance_level()
	else:
		push_warning("GameController não encontrado — não foi possível avançar de nível automaticamente.")
	queue_free()

# busca recursiva por um dos nomes fornecidos
func _find_node_by_any_name(root: Node, names: Array) -> Node:
	for child in root.get_children():
		if child.name in names:
			return child
		var found = _find_node_by_any_name(child, names)
		if found != null:
			return found
	return null
