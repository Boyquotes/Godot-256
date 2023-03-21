extends Sprite

onready var anim = $AnimationPlayer
onready var get_main_scene = get_tree().get_root().get_node("Main")


func _ready():
	if not  get_main_scene.selected_units.empty():
		modulate = get_main_scene.selected_units[0].get_modulate()

func _input(event):
	pass



func _on_AnimationPlayer_ready():
	var anim = $AnimationPlayer
	anim.play("fade_in")


func _on_TargetMark_body_entered(body):
	pass
	#anim.play("fade_out")
