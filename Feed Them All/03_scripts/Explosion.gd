extends Node2D


onready var part_1 = $Part1


func _ready():
	part_1.one_shot = true

func gone():
	queue_free()
