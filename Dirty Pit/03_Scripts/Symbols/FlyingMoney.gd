extends Node2D

var flying_money = "-1"


func setup(amount,direction):
	match direction:
		"UP":
			flying_money = "-" + str(amount)
			$Anim.play("Up")
		"DOWN":
			flying_money = "+" + str(amount)
			$Anim.play("Down")

func _ready():
	$Label.text = flying_money


func disappear():
	queue_free()

