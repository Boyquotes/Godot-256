extends Node2D

var glob_position = Vector2(470,270)

onready var tween = $Tween

func _ready():
	show_description()

func show_description():
	tween.interpolate_property(self, "position",
glob_position, (glob_position + Vector2(0,300)), 2,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "modulate",
Color(1,1,1,1),Color(1,1,1,0), 2,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")
	queue_free()
