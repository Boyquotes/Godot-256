extends AnimationTree

func _ready():
	pass # Replace with function body.

func transitions_for_commands(data):
	var command = data[0].name
	var state = data[1].name
	match state:
		"SwingSidewaysState":
			match command:
				"SwingSideways":
					set("parameters/Transition/current", 0)
		"ReadyState":
			match command:
				"Ready":
					set("parameters/Transition/current", 1)
		"ReadyIdleState":
			match command:
				"ReadyIdle":
					set("parameters/Transition/current", 2)
		"DefendTopState":
			match command:
				"DefendTop":
					set("parameters/Transition/current", 3)
		"DefendMidState":
			match command:
				"DefendMid":
					set("parameters/Transition/current", 4)
		"DefendBotState":
			match command:
				"DefendBot":
					set("parameters/Transition/current", 5)
		"AttackTopState":
			match command:
				"AttackTop":
					set("parameters/Transition/current", 6)
		"AttackMidState":
			match command:
				"AttackMid":
					set("parameters/Transition/current", 7)
		"AttackBotState":
			match command:
				"AttackBot":
					set("parameters/Transition/current", 8)
		"UnReadyState":
			match command:
				"UnReady":
					set("parameters/Transition/current", 9)
		"NoActionState":
			match command:
				"NoAction":
					set("parameters/Transition/current", 10)
		"AttackTopFailState":
			match command:
				"AttackTopFail":
					set("parameters/Transition/current", 11)
		"AttackTopSuccessState":
			match command:
				"AttackTopSuccess":
					set("parameters/Transition/current", 12)
		"AttackMidFailState":
			match command:
				"AttackMidFail":
					set("parameters/Transition/current", 13)
		"AttackMidSuccessState":
			match command:
				"AttackMidSuccess":
					set("parameters/Transition/current", 14)
		"AttackBotFailState":
			match command:
				"AttackBotFail":
					set("parameters/Transition/current", 15)
		"AttackBotSuccessState":
			match command:
				"AttackBotSuccess":
					set("parameters/Transition/current", 16)
		"MoveINState":
			match command:
				"MoveIN":
					set("parameters/Transition/current", 17)
		"MoveOUTState":
			match command:
				"MoveOUT":
					set("parameters/Transition/current", 18)
		"DefendTopLongState":
			match command:
				"DefendTopLong":
					set("parameters/Transition/current", 19)
		"DefendMidLongState":
			match command:
				"DefendMidLong":
					set("parameters/Transition/current", 20)
		"DefendBotLongState":
			match command:
				"DefendBotLong":
					set("parameters/Transition/current", 21)
		"DefeatedState":
			match command:
				"Defeated":
					set("parameters/Transition/current", 22)
