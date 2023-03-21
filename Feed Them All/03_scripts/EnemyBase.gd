

tool
extends Sprite

func _ready():
	update_shader_aspect_ratio()

func update_shader_aspect_ratio():
	material.set_shader_param("aspect_ratio", scale.y/scale.x)

func _on_ColorRect_item_rect_changed():
	update_shader_aspect_ratio()
