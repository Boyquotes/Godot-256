extends Node2D

var start_position = Vector2(0,0)
var direction

var x_for_hero_atc_pos = 600
var x_for_opponent_act_pos = 400
var x_for_hero_def_pos = 400
var x_for_opponent_def_pos = 600
var y_for_top = 200
var y_for_mid = 300
var y_for_bot = 400

onready var tween = $Tween

func _ready():
	show_description()


func setup(action,who):
	match action:
		0:
			$Label.text = "def top"
			start_position.y = y_for_top
			match who:
				0:
					start_position.x = x_for_hero_def_pos
					direction = 0
				1:
					start_position.x = x_for_opponent_def_pos
					direction = 0
					get_node("Action/TopDef").visible = true
		1:
			$Label.text = "def mid"
			start_position.y = y_for_mid
			match who:
				0:
					start_position.x = x_for_hero_def_pos
					direction = 0
				1:
					start_position.x = x_for_opponent_def_pos
					direction = 0
					get_node("Action/MidDef").visible = true
		2:
			$Label.text = "def bot"
			start_position.y = y_for_bot
			match who:
				0:
					start_position.x = x_for_hero_def_pos
					direction = 0
				1:
					start_position.x = x_for_opponent_def_pos
					direction = 0
					get_node("Action/BotDef").visible = true
		3:
			$Label.text = "atc top"
			start_position.y = y_for_top
			match who:
				0:
					start_position.x = x_for_hero_atc_pos
					direction = 1
				1:
					start_position.x = x_for_opponent_act_pos
					direction = -1
					get_node("Action/TopAtck").visible = true
		4:
			$Label.text = "atc mid"
			start_position.y = y_for_mid
			match who:
				0:
					start_position.x = x_for_hero_atc_pos
					direction = 1
				1:
					start_position.x = x_for_opponent_act_pos
					direction = -1
					get_node("Action/MidAtck").visible = true
		5:
			$Label.text = "atc bot"
			start_position.y = y_for_bot
			match who:
				0:
					start_position.x = x_for_hero_atc_pos
					direction = 1
				1:
					start_position.x = x_for_opponent_act_pos
					direction = -1
					get_node("Action/BotAtck").visible = true



func show_description():
	tween.interpolate_property(self, "position",
start_position, (start_position + Vector2(100,0)*direction), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "modulate",
Color(1,1,1,1),Color(1,1,1,0), 2,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")
	queue_free()



