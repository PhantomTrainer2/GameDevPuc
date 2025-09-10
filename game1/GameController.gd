extends Node

var player1_score: int = 0
var player2_score: int = 0
var score_limit = 10

func end_game():
	if (player1_score >= 9 and player1_score == player2_score):
		score_limit = score_limit + 1
	if (player1_score >= score_limit or player2_score >= score_limit):
		player1_score = 0
		player2_score = 0

func reset_game():
	player1_score = 0
	player2_score = 0
	get_tree().call_deferred("change_scene_to_file", "res://menu.tscn")
