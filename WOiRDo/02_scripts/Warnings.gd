extends Control

export(NodePath) var WarningsTween
onready var warningstween

func _ready():
	warningstween = get_node(WarningsTween)
	visible=false
	for child in get_children():
		if not child.name=="ColorRect":
			child.visible=false
	pass # Replace with function body.

func bb_show_warning1():
	visible=true
	$Warning1.visible=true

func bb_show_warning2():
	visible=true
	$Warning2.visible=true

func bb_show_warning3():
	visible=true
	$Warning3.visible=true

func bb_show_warning4(nr):
	$Warning4/Sign3.read_sign(str(nr))
	visible=true
	$Warning4.visible=true

func bb_show_warning5(d,m,y):
	$Warning5/Sign4.read_sign(str(d)+" "+Content.bb_print_month_name(m))
	$Warning5/Sign5.read_sign(str(y))
	visible=true
	$Warning5.visible=true

func bb_show_warning6():
	visible=true
	$Warning6.visible=true

func bb_show_warning7():
	visible=true
	$Warning7.visible=true
