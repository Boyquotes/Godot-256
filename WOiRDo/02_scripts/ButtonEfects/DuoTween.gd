extends Tween



var button_texture
var used_button_nr=-1
var but_origin_scale = Vector2(1,1)
var but_origin_position = Vector2(0,0)
var but_origin_size = Vector2(0,0)
var but_destination_scale = Vector2(0.8,0.8)
var but_from_down_scale = Vector2(1.4,1.4)
var but_destination_position = Vector2(320,280)


export var time_shrinking = 0.15
export var time_back = 0.05

var anim_stoped=false

export(NodePath) var content



func _ready():
	pass # Replace with function body.

func bb_reset_used_button_nr():
	used_button_nr=-1

func bb_animate_pressing_button(day_nr,month_nr,year_nr,duo_nr):
	var button_nr=day_nr*(month_nr*2)*year_nr

	remove_all()
	if used_button_nr!=-1:
		button_texture.rect_scale = but_origin_scale
		button_texture.rect_position = but_origin_position
		button_texture.rect_size = but_origin_size
	anim_stoped=false


	var wordlist = "From"+"_"+str(day_nr)+"_"+str(month_nr)+"_"+str(year_nr)
	button_texture=get_node(content).get_node(wordlist+"/Buttons/Button_"+str(duo_nr))

	



	if used_button_nr!=button_nr:
		but_origin_position=button_texture.rect_position
		but_origin_size=button_texture.rect_size
		but_origin_scale=button_texture.rect_scale
		used_button_nr=button_nr



	but_destination_position=but_origin_position+but_origin_size/2-but_origin_size*but_destination_scale.x/2
	interpolate_property(button_texture,"rect_scale",but_origin_scale,but_destination_scale,time_shrinking,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	interpolate_property(button_texture,"rect_position",but_origin_position,but_destination_position,time_shrinking,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	start()



func bb_animatation_stopped(day_nr,month_nr,year_nr,duo_nr):
	anim_stoped=true
	remove_all()

	var wordlist = "From"+"_"+str(day_nr)+"_"+str(month_nr)+"_"+str(year_nr)
	button_texture=get_node(content).get_node(wordlist+"/Buttons/Button_"+str(duo_nr))


	but_destination_position=but_origin_position-(but_origin_size*but_from_down_scale.x-but_origin_size)/2

	interpolate_property(button_texture,"rect_scale",button_texture.rect_scale,
		but_from_down_scale,time_back,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	interpolate_property(button_texture,"rect_position",button_texture.rect_position,
		but_destination_position,time_back,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	start()



func _on_DuoTween_tween_all_completed():
	used_button_nr=-1
	if anim_stoped:
		remove_all()
		button_texture.rect_scale = but_origin_scale
		button_texture.rect_position = but_origin_position
		button_texture.rect_size = but_origin_size
