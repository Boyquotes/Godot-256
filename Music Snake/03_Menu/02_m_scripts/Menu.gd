extends Control

var music_on = 0
var sound_on = 0

func _ready():
	pass # Replace with function body.


func enable_buttons():
	for button in $Buttons.get_children():
		button.disabled = false


func _on_StartGame_button_down():
	GlobalSignals.emit_signal("make_click_sound", 1)
func _on_StartGame_button_up():
	pass # Replace with function body.
func _on_StartGame_toggled(button_pressed):
	print("start is working")
	GlobalSignals.emit_signal("make_click_sound", 1)
	GlobalSignals.emit_signal("start_game_clicked")


func _on_Sounds_button_down():
	GlobalSignals.emit_signal("make_click_sound", 1)
func _on_Sounds_button_up():
	pass # Replace with function body.
func _on_Sounds_toggled(button_pressed):
	print("sound is working")
	GlobalSignals.emit_signal("make_click_sound", 1)
	GlobalSignals.emit_signal("sounds_clicked")
	sound_on += 1
	if sound_on%2 == 1:
		$Buttons/Sounds/TextureRect.modulate = Color(0,0,0,1)
	else:
		$Buttons/Sounds/TextureRect.modulate = Color(1,1,1,1)


func _on_Music_button_down():
	GlobalSignals.emit_signal("make_click_sound", 1)
func _on_Music_button_up():
	pass # Replace with function body.
func _on_Music_toggled(button_pressed):
	print("music is working")
	GlobalSignals.emit_signal("make_click_sound", 1)
	GlobalSignals.emit_signal("music_clicked")
	music_on += 1
	if music_on%2 == 1:
		$Buttons/Music/TextureRect.modulate = Color(0,0,0,1)
	else:
		$Buttons/Music/TextureRect.modulate = Color(1,1,1,1)


func _on_Exit_button_down():
	GlobalSignals.emit_signal("make_click_sound", 1)
func _on_Exit_button_up():
	pass # Replace with function body.
func _on_Exit_toggled(button_pressed):
	get_tree().quit()

