extends Control

export(NodePath) var specialkeyboardtween
export(NodePath) var LanguagesTween
export(NodePath) var MoveListTween

var but_pressed=false

var mode=0
var language="PL"

var key_placement=[]

func _ready():
	$Language.visible=false
	visible=false
	var button_nr=0
	for but in $Buttons.get_children():
		but.connect("gui_input",self,"bb_button_input",[button_nr])
		button_nr+=1
	bb_activate_language("PL")

func bb_activate_language(lang):
	$Language.visible=false
	for but in $Buttons.get_children():
		but.get_node("Texture").visible=false
	language=lang
	var lower_case_lang=lang.to_lower()
	var short_prop="number_of_"+lang+"_letters"
	if lang=="NO":
		lower_case_lang="dk"
		short_prop="number_of_"+"DK"+"_letters"
	for i in LettersAndNumbers.get(short_prop):
		if i <=8:
			$Buttons.get_node("TextureRect%d/Texture"%[i]).texture = LettersAndNumbers.get(lower_case_lang+"_00%d"%(i+1))
		else:
			$Buttons.get_node("TextureRect%d/Texture"%[i]).texture = LettersAndNumbers.get(lower_case_lang+"_0%d"%(i+1))
		$Buttons.get_node("TextureRect%d/Texture"%[i]).visible=true



func bb_button_input(event,nr):
	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
		if event.is_pressed():
#			print("Button down: " +str(letter))
			but_pressed=true
			get_node(specialkeyboardtween).bb_animate_pressing_button(nr)
		if not event.is_pressed():
#			print("Button up: " +str(letter))
			if but_pressed:
				but_pressed=false
				match mode:
					0:
						Signals.emit_signal("letter_poked","[",language,nr+1)
					1:
						Signals.emit_signal("letter_poked_in_quest","[",language,nr+1)
				get_node(specialkeyboardtween).bb_animatation_stopped(nr)



func _on_29_gui_input(event):
	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
		if event.is_pressed():
			but_pressed=true
			get_node(specialkeyboardtween).bb_animate_pressing_button(100)
		if not event.is_pressed():
			if but_pressed:
				but_pressed=false
				$Language.visible=true
				get_node(specialkeyboardtween).bb_animatation_stopped(100)

func _on_31_gui_input(event):
	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
		if event.is_pressed():
			but_pressed=true
			get_node(specialkeyboardtween).bb_animate_pressing_button(101)
		if not event.is_pressed():
			if but_pressed:
				but_pressed=false
				Signals.emit_signal("hide_special_keybord")
				get_node(specialkeyboardtween).bb_animatation_stopped(101)


func _on_CZ_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(0)
func _on_CZ_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(0)
		bb_activate_language("CZ")

func _on_DE_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(1)
func _on_DE_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(1)
		bb_activate_language("DE")

func _on_DK_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(2)
func _on_DK_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(2)
		bb_activate_language("DK")

func _on_EE_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(3)
func _on_EE_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(3)
		bb_activate_language("EE")

func _on_ESP_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(4)
func _on_ESP_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(4)
		bb_activate_language("ESP")
func _on_ESP_toggled():
	pass # Replace with function body.

func _on_FI_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(5)
func _on_FI_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(5)
		bb_activate_language("FI")


func _on_FR_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(6)
func _on_FR_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(6)
		bb_activate_language("FR")

func _on_HR_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(7)
func _on_HR_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(7)
		bb_activate_language("HR")

func _on_LT_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(8)
func _on_LT_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(8)
		bb_activate_language("LT")

func _on_LV_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(9)
func _on_LV_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(9)
		bb_activate_language("LV")

func _on_NO_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(10)
func _on_NO_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(10)
		bb_activate_language("NO")

func _on_PL_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(11)
func _on_PL_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(11)
		bb_activate_language("PL")

func _on_PT_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(12)
func _on_PT_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(12)
		bb_activate_language("PT")

func _on_RO_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(13)
func _on_RO_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(13)
		bb_activate_language("RO")

func _on_SE_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(14)
func _on_SE_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(14)
		bb_activate_language("SE")

func _on_SK_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(15)
func _on_SK_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(15)
		bb_activate_language("SK")

func _on_SL_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(16)
func _on_SL_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(16)
		bb_activate_language("SL")


func _on_TR_button_down():
	but_pressed=true
	get_node(LanguagesTween).bb_animate_pressing_button(17)
func _on_TR_button_up():
	if but_pressed:
		but_pressed=false
		get_node(LanguagesTween).bb_animatation_stopped(17)
		bb_activate_language("TR")
