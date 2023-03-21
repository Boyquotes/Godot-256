extends AnimationTree

func _ready():
	pass # Replace with function body.

func transitions_for_commands(data):
	var command = data[0].name
	var state = data[1].name
	match state:
		"InBattleState":
			match command:
				"Waiting":
					set("parameters/Transition/current", 0)
		"MovingState":
			match command:
				"Moving":
					set("parameters/Transition/current", 1)
		"MovingAwayState":
			match command:
				"MovingAway":
					set("parameters/Transition/current", 2)
		"EatedState":
			match command:
				"BeingEated":
					set("parameters/Transition/current", 3)
		"SendToBaseState":
			match command:
				"SendToBase":
					set("parameters/Transition/current", 4)
		"SendToBaseState2":
			match command:
				"SendToBase2":
					set("parameters/Transition/current", 4)
		"PrepareNewGameState":
			match command:
				"PrepareNewGame":
					set("parameters/Transition/current", 4)
		"DieingState":
			match command:
				"Dieing":
					set("parameters/Transition/current", 5)
		"TakingOutOfBoxState":
			match command:
				"TakingOutOfBox":
					set("parameters/Transition/current", 7)
