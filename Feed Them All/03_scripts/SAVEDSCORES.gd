extends CanvasLayer

signal sent_me_back_to_menu

onready var get_main_scene = get_tree().get_root().get_node("Main")

func _ready():
	connect("sent_me_back_to_menu",get_main_scene,"_back_to_menu")


func _on_TextureButton_button_down():
	$BackButton.rect_position.y = 660
func _on_TextureButton_button_up():
	$BackButton.rect_position.y = 650
func _on_TextureButton_toggled(button_pressed):
	emit_signal("sent_me_back_to_menu")
