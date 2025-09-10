extends Label

@export var player: int = 1  # 1 = player1, 2 = player2

func _process(_delta: float) -> void:
	if player == 1:
		text = str(GameController.player1_score)
	else:
		text = str(GameController.player2_score)
