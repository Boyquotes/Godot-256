extends Node2D

var text = "-1"

func setup(number = 1):
	text = "-" + str(number)

func _ready():
	$Label.text = text


func gone():
	queue_free()
