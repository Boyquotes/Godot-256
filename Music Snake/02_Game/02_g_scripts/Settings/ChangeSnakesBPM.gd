extends Control

var screen_touched = false

func _ready():
	$TextureProgress.value=20
	$MarginContainer/Sign.read_sign(str(70))
	pass # Replace with function body.


func bb_change_snakes_bpm(value):
	$TextureProgress.value=(value+20)
	get_node("MarginContainer/Sign").read_sign( str(value+70))


func _on_VScrollBar_value_changed(value):
	bb_change_snakes_bpm(value)


func _on_VScrollBar_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and not screen_touched:
			screen_touched = true
			InGameSignals.emit_signal("i_am_changing_bpm")
		elif screen_touched:
			screen_touched = false
			InGameSignals.emit_signal("i_am_finished_changing_bpm",$TextureProgress.value+70-20)

