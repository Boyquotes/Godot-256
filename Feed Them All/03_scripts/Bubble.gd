extends AnimatedSprite

signal release_kraken


var playing_backwards = false
onready var timer = $Timer

#func yield_manipulator():
#	pending_yield = yield(timer,"timeout")
#	if (pending_yield and pending_yield==11):
#		print("stopped")
#		timer.stop()
#		return
#	print("queue_free")
#	queue_free()

func yield_manipulator():
	yield(timer,"timeout")
	queue_free()

var pending_yield

func _ready():
	timer.wait_time = 40
	#connect("release_kraken",get_tree().root.get_node("Main").get_node("Background"),"_spawn_enemy")
	yield_manipulator()

func _on_Bubble_frame_changed():
	if playing_backwards:
		if frame == 0:
			pass
#			if yield_manipulator().is_valid():
#				yield_manipulator().resume(11)
#			queue_free()
	if frame == 63:
		emit_signal("release_kraken")


func stop_bubble():
	if frame < 63 and not playing_backwards:
		stop()
		play(animation,true)
		playing_backwards = true

