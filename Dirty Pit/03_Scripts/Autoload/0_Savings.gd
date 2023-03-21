## SAVING ###

extends Node


export(Script) var game_save_class


func _save_score():
	var new_save = game_save_class.new()
	new_save.dif_1 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/Difficulty.text
	new_save.lev_1 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/LevelNumber.text
	new_save.kills_1 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/KillNumber.text
	new_save.dif_2 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/Difficulty.text
	new_save.lev_2 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/LevelNumber.text
	new_save.kills_2 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/KillNumber.text
	new_save.dif_3 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/Difficulty.text
	new_save.lev_3 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/LevelNumber.text
	new_save.kills_3 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/KillNumber.text
	new_save.dif_4 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/Difficulty.text
	new_save.lev_4 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/LevelNumber.text
	new_save.kills_4 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/KillNumber.text
	new_save.dif_5 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/Difficulty.text
	new_save.lev_5 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/LevelNumber.text
	new_save.kills_5 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/KillNumber.text
	new_save.dif_6 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/Difficulty.text
	new_save.lev_6 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/LevelNumber.text
	new_save.kills_6 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/KillNumber.text
	new_save.dif_7 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/Difficulty.text
	new_save.lev_7 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/LevelNumber.text
	new_save.kills_7 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/KillNumber.text
	new_save.dif_8 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/Difficulty.text
	new_save.lev_8 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/LevelNumber.text
	new_save.kills_8 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/KillNumber.text
	new_save.dif_9 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/Difficulty.text
	new_save.lev_9 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/LevelNumber.text
	new_save.kills_9 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/KillNumber.text
	new_save.dif_10 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/Difficulty.text
	new_save.lev_10 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/LevelNumber.text
	new_save.kills_10 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/KillNumber.text
#	ResourceSaver.save("res://04_Savings/MySavings.tres", new_save)
	ResourceSaver.save("user://MySavings.res", new_save)

func verfy_save(saved_score):
	for v in save_vars:
		if saved_score.get(v) == null:
			return false
	return true

func _load_saved_score():
	var dir = Directory.new()
	if not dir.file_exists("user://MySavings.res"):
		return false
	var saved_score = load("user://MySavings.res")
	if not verfy_save(saved_score):
		return false
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/Difficulty.text = saved_score.dif_1
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/LevelNumber.text = saved_score.lev_1
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/KillNumber.text = saved_score.kills_1
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/Difficulty.text = saved_score.dif_2
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/LevelNumber.text = saved_score.lev_2
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/KillNumber.text = saved_score.kills_2
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/Difficulty.text = saved_score.dif_3
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/LevelNumber.text = saved_score.lev_3
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/KillNumber.text = saved_score.kills_3
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/Difficulty.text = saved_score.dif_4
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/LevelNumber.text = saved_score.lev_4
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/KillNumber.text = saved_score.kills_4
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/Difficulty.text = saved_score.dif_5
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/LevelNumber.text = saved_score.lev_5
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/KillNumber.text = saved_score.kills_5
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/Difficulty.text = saved_score.dif_6
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/LevelNumber.text = saved_score.lev_6
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/KillNumber.text = saved_score.kills_6
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/Difficulty.text = saved_score.dif_7
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/LevelNumber.text = saved_score.lev_7
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/KillNumber.text = saved_score.kills_7
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/Difficulty.text = saved_score.dif_8
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/LevelNumber.text = saved_score.lev_8
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/KillNumber.text = saved_score.kills_8
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/Difficulty.text = saved_score.dif_9
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/LevelNumber.text = saved_score.lev_9
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/KillNumber.text = saved_score.kills_9
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/Difficulty.text = saved_score.dif_10
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/LevelNumber.text = saved_score.lev_10
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/KillNumber.text = saved_score.kills_10
	return true
