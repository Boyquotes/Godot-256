extends "res://02_Game/02_g_scripts/StateMachines/PlatformCommand.gd"

export var speed := 400

var local_head_orien = Vector2(0,0)


func _ready():
	pass

func _unhandled_input(event):
	pass

func _physics_process(delta):
	bb_crawl(delta)
	global_values.bb_create_pivot_point(actor,global_values)
	pass

func _start_function():
	bb_find_new_head_orientation()
	pass

func _finish_function():
	pass

#OTHER FUNCTIONS

func bb_crawl(delta):
	actor.position += local_head_orien.normalized() * speed * delta

func bb_find_new_head_orientation():
	local_head_orien = (actor.transform.xform(actor.get_node("Orientation/Top").position)-actor.position).normalized()
	actor.state_machine.get_node("InFieldState/InField")


