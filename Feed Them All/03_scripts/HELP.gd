extends CanvasLayer

signal sent_me_back_to_menu

onready var get_main_scene = get_tree().get_root().get_node("Main")

func _ready():
	connect("sent_me_back_to_menu",get_main_scene,"_back_to_menu")

func _on_Button_pressed():
	emit_signal("sent_me_back_to_menu")


func _on_StartVideo_pressed():
	$Plate/VideoPlayer.play()
	if $Plate/VideoPlayer.paused:
		$Plate/VideoPlayer.paused = false


func _on_Pause_pressed():
	if $Plate/VideoPlayer.paused:
		$Plate/VideoPlayer.paused = false
	else:
		$Plate/VideoPlayer.paused = true
