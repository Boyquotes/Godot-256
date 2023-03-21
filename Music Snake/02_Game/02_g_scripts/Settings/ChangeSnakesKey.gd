extends Control

export (NodePath) var key_sign_path 


var original_key = 0
var actual_key = 0

var list_of_keys =["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
var list_of_keys_increasing =["C","C#","D","D#","E","F","F#","G","G#","A","A#","B","Cm","C#m","Dm","D#m","Em","Fm","F#m","Gm","G#m","Am","A#m","Bm"]
var list_of_keys_decreasing =["C","Db","D","Eb","E","F","Gb","G","Ab","A","Bb","B","Cm","Dbm","Dm","Ebm","Em","Fm","Gbm","Gm","Abm","Am","Bbm","Bm"]

func _ready():
	get_node(key_sign_path).read_sign(list_of_keys[actual_key])


func bb_show_next_key(value):
	var new_key = actual_key + value
	if new_key == 24:
		actual_key = 0
	elif new_key == -1:
		actual_key = 23
	else:
		actual_key = new_key
#	get_node(key_sign_path).read_sign(list_of_keys[actual_key])
	match value:
		1:
			get_node(key_sign_path).read_sign(list_of_keys_increasing[actual_key])
		-1:
			get_node(key_sign_path).read_sign(list_of_keys_decreasing[actual_key])


func _on_KeyPrevious_button_down():
	pass # Replace with function body.
func _on_KeyPrevious_button_up():
	bb_show_next_key(-1)

func _on_KeyNext_button_down():
	pass # Replace with function body.
func _on_KeyNext_button_up():
	bb_show_next_key(1)
