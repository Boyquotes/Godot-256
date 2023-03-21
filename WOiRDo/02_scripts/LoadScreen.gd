extends Control

func _ready():
	pass # Replace with function body.

func bb_update_node(nr):
	$ProgressBar.max_value=nr


func bb_update_progress(value):
	$ProgressBar.value=value

