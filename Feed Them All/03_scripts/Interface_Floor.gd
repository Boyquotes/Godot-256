
tool
extends TextureRect

func _ready():
	#update_shader_aspect_ratio()
	pass

func update_shader_aspect_ratio():
	material.set_shader_param("aspect_ratio", rect_scale.y/rect_scale.x)

func _on_Floor_item_rect_changed():
	#update_shader_aspect_ratio()
	pass
