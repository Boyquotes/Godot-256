extends Tween

var button_texture
var button_texture_origin_scale = Vector2(1,1)
var button_texture_origin_position = Vector2(0,0)
var button_texture_destination_scale = Vector2(0.2,0.2)
var button_texture_destination_position = Vector2(320,280)


func _ready():
	pass # Replace with function body.


func bb_animate_pressing_button(snake_nr,button_nr):
	var button_type = ""
	match button_nr:
		1:
			button_type = "Play"
		2:
			button_type = "Mute"
		3:
			button_type = "Delete"
	button_texture = get_node("../SnakesButtons/Snake"+str(snake_nr)+"/Snake"+str(snake_nr)+"/VBox/"+button_type+"/"+button_type+"_snake"+str(snake_nr)+"_button/Texture")
	interpolate_property(button_texture,"rect_scale",button_texture_origin_scale,button_texture_destination_scale,5,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	interpolate_property(button_texture,"rect_position",button_texture_origin_position,button_texture_destination_position,5,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	start()

func bb_animatation_stopped():
	if is_active():
		stop(button_texture,"rect_scale")
		stop(button_texture,"rect_position")
	button_texture.rect_scale = button_texture_origin_scale
	button_texture.rect_position = button_texture_origin_position
