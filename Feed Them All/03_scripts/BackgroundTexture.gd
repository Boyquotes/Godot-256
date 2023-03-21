
tool
extends TextureRect

func _ready():
	pass
#	update_shader_aspect_ratio()

func update_shader_aspect_ratio():
	material.set_shader_param("aspect_ratio", rect_scale.y/rect_scale.x)

func _on_ColorRect_item_rect_changed():
	update_shader_aspect_ratio()

func _on_BackgroundTexture_item_rect_changed():
	update_shader_aspect_ratio()
