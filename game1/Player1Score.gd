extends Label

@export var player: int = 1  # 1 = player1, 2 = player2

func _process(delta: float) -> void:
	if player == 1:
		text = "Player1: " + str(GameController.player1_score)
	else:
		text = "Player2: " + str(GameController.player2_score)
