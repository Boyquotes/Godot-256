extends Control

onready var anim = $Anim
onready var pause = $PauseButtBoard/Pause
onready var continue_but = $PauseBoard/TextureRect/Center/Options/Continue
onready var resign = $PauseBoard/TextureRect/Center/Options/Resign
onready var pause_tween = $PauseButtBoard/PauseTween

var pause_but_start_pos = Vector2(50,-100)
var pause_but_play_pos = Vector2(50,50)
var wait_time_for_button = 1.5

func _ready():
	pause_button_in_start_pos()
	
	pass # Replace with function body.


func pause_button_in_start_pos():
	$PauseButtBoard.rect_position.y=-70
	$PauseBoard.rect_position.y = -388

func _on_Pause_button_down():
	pass # Replace with function body.
func _on_Pause_button_up():
	GlobalSignals.emit_signal("_game_paused")
	pause.disabled = true
	get_tree().paused = true
	anim.play_backwards("Move_PauseButton")
	if anim.is_playing():
		yield(anim,"animation_finished")
	anim.play("Move_PauseBoard")
	if anim.is_playing():
		yield(anim,"animation_finished")
	continue_but.disabled = false
	resign.disabled = false

func _on_Continue_button_down():
	pass # Replace with function body.
func _on_Continue_button_up():
	continue_but.disabled = true
	resign.disabled = true
	anim.play_backwards("Move_PauseBoard")
	if anim.is_playing():
		yield(anim,"animation_finished")
	anim.play("Move_PauseButton")
	if anim.is_playing():
		yield(anim,"animation_finished")
	GlobalSignals.emit_signal("_game_unpaused")
	pause.disabled = false
	get_tree().paused = false


func _on_Resign_button_down():
	pass # Replace with function body.
func _on_Resign_button_up():
	get_tree().paused = false
	anim.play_backwards("Move_PauseBoard")
	if anim.is_playing():
		yield(anim,"animation_finished")
	GlobalSignals.emit_signal("_resign_from_fight")


func show_pausebuttboard():
	pause_tween.interpolate_property($PauseButtBoard, "rect_position",
pause_but_start_pos,pause_but_play_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	pause_tween.start()
	yield(pause_tween,"tween_completed")
	$PauseButtBoard/Pause.disabled = false
func hide_pausebuttboard():
	$PauseButtBoard/Pause.disabled = true
	pause_tween.interpolate_property($PauseButtBoard, "rect_position",
pause_but_play_pos,pause_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	pause_tween.start()
