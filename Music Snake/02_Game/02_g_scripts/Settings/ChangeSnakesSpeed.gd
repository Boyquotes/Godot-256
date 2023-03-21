extends Control

var actual_value = 0

export (NodePath) var player_node = ".."


func _ready():
	$Bar.value = 5
	actual_value = $Bar.value


func _on_Bar_value_changed(value):
	if value - actual_value > 0:
		$Control/ProgBar.bb_add_point(value - actual_value)
	else:
		$Control/ProgBar.bb_sub_point(abs(value - actual_value))
	actual_value = value

	for snake in get_node(player_node).get_children():
		if not snake.name=="Tween":
			snake.speed = value *100



