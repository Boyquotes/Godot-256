extends Control

var active = true

func _ready():
	bb_change_activity()

func bb_change_activity():
	active = !active
	$TextureRect.visible = active


