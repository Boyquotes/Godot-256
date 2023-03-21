extends Node2D

func _input(event):
	if event is InputEventKey and event.scancode==KEY_SPACE:
		if event.is_pressed() and not event.is_echo():
			print("space is working")
			test()

func _ready():
	pass # Replace with function body.

func test():
	$Tween.interpolate_property($Sprite,"scale",Vector2(5,5),Vector2(1,1),2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.get_runtime()
	print("runtime is: "+ str($Tween.get_runtime()))
	$Tween.start()

func _on_Tween_tween_started(object, key):
	print("sr=tarted")
	pass # Replace with function body.

func _on_Tween_tween_completed(object, key):
	print("completed")
	pass # Replace with function body.
