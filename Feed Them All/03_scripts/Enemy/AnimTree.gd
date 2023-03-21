extends AnimationTree

func _ready():
	pass # Replace with function body.

func transitions_for_commands(data):
	var command = data[0].name
	var state = data[1].name
	match state:
		"PreparingState":
			match command:
				"Prepare":
					set("parameters/Transition/current", 0)
		"SwimmingState":
			match command:
				"Swim":
					set("parameters/Transition/current", 1)
		"HittingBaseState":
			match command:
				"HittingBase":
					set("parameters/Transition/current", 2)
		"EatingState":
			match command:
				"Eating":
					set("parameters/Transition/current", 3)
		"DieingState":
			match command:
				"Dieing":
					set("parameters/Transition/current", 4)

