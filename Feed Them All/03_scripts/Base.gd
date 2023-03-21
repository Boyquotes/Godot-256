extends MenuButton

onready var get_main_scene = get_tree().get_root().get_node("Main")
signal spawn
signal update

func _ready():
	#fade button /// connect signals for mouse hover
	modulate = Color(1,1,1,1)
	connect("mouse_entered",self,"_on_Base_mouse_entered")
	connect("mouse_exited",self,"_on_Base_mouse_exited")
	#popup
	get_popup().connect("id_pressed",self,"_on_item_presed")
	connect("spawn",get_main_scene,"_spawn_unit")
	connect("update",get_main_scene,"_update_number")


func _on_Base_mouse_entered():
	modulate = Color(0.7,0,0.9,0.3)

func _on_Base_mouse_exited():
	modulate = Color(1,1,1,1)

func _on_item_presed(ID):
	emit_signal("spawn", ID)
	emit_signal("update",ID)
