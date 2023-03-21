extends "res://02_Game/02_g_scripts/StateMachines/PlatformCommand.gd"

export var max_turn_sum = 180
export var head_orien_speed_change := 150
var speed := 300

var acceleration_per_frame = 5
var additional_speed = 0
export var max_acceleration = 500

var local_head_orien = Vector2(0,0)
var screen_touched = false
var turn_dir = 0
var turn_sum = 0

func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and not screen_touched:
			bb_set_turn_dir(event,actor)
			screen_touched = true
		elif screen_touched:
			screen_touched = false
			additional_speed = 0
			global_values.bb_accelerate_all_torsos(additional_speed)

#	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
#		if event.is_pressed() and not event.is_echo():
#			print("clicked left")
#			actor.position = Vector2(100,1000)
#			actor.position = Vector2(1300,330)
#	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
#		if event.is_pressed() and not event.is_echo():
#			print("clicked right")
#			actor.position = Vector2(2200,1000)
#			actor.position = Vector2(1300,3770)
#	if event is InputEventKey and event.scancode==KEY_SPACE:
#		if event.is_pressed() and not event.is_echo():
#			var x = bb_find_new_head_orientation()
#			print("space clicked " +str(x))
#			actor.position = Vector2(700,1000)
#			actor.position = Vector2(1300,2330)
#	if event is InputEventKey and event.scancode==KEY_M:
#		if event.is_pressed() and not event.is_echo():
#			print("M clicked")
#			actor.position = Vector2(1300,1530)

func _physics_process(delta):
	bb_crawl(delta)
	global_values.bb_create_pivot_point(actor,global_values)
	if screen_touched:
		if turn_sum < max_turn_sum:
			local_head_orien = bb_change_head_orientation(actor,local_head_orien, turn_dir, delta)
			bb_accelerate()
	pass

func _start_function():
	local_head_orien=bb_find_new_head_orientation()

	pass

func _finish_function():
	screen_touched = false
	additional_speed = 0
	global_values.bb_accelerate_all_torsos(additional_speed)
	pass

#OTHER FUNCTIONS

func bb_crawl(delta):
	actor.position += local_head_orien.normalized() * (speed+additional_speed) * delta
#	global_values.get_node("SnakeInterface").rect_position = actor.position - global_values.screen_size/2

func bb_accelerate():
	if not additional_speed>max_acceleration:
		additional_speed += acceleration_per_frame
		global_values.bb_accelerate_all_torsos(additional_speed)


func bb_set_turn_dir(event,somebody):
	turn_sum = 0
	if abs(local_head_orien.y) > abs(local_head_orien.x):
		if local_head_orien.y > 0:
#			if event.position.x < somebody.position.x:
			if somebody.get_global_mouse_position().x < somebody.position.x:
				turn_dir = 1
			else:
				turn_dir = 0
		else:
#			if event.position.x < somebody.position.x:
			if somebody.get_global_mouse_position().x < somebody.position.x:
				turn_dir = 0
			else:
				turn_dir = 1
	else:
		if local_head_orien.x > 0:
#			if event.position.y < somebody.position.y:
			if somebody.get_global_mouse_position().y < somebody.position.y:
				turn_dir = 0
			else:
				turn_dir = 1
		else:
#			if event.position.y < somebody.position.y:
			if somebody.get_global_mouse_position().y < somebody.position.y:
				turn_dir = 1
			else:
				turn_dir = 0

func bb_change_head_orientation(somebody,old_vec, side, delta):
	var new_head_orientation := Vector2.ZERO
	turn_sum += head_orien_speed_change*delta
	match side:
		0:
			actor.rotation_degrees -= head_orien_speed_change*delta
		1:
			actor.rotation_degrees += head_orien_speed_change*delta

	if actor.rotation_degrees >= 360 or actor.rotation_degrees <= -360 :
		actor.rotation_degrees = 0
	new_head_orientation=bb_find_new_head_orientation()
	return  new_head_orientation

func bb_find_new_head_orientation():
	var new_head_orien = (actor.transform.xform(actor.get_node("Orientation/Top").position)-actor.position).normalized()
	return new_head_orien


