extends HBoxContainer

export var word:=""
export var texture_size = Vector2(156,256)
export (bool) var centred = true


var _letter_hight
var word_on_screen:= ""
var container_width = 100.0

func _ready():
	#LettersAndNumbers = get_tree().root.get_node("MainScene/Letters")
	_letter_hight = rect_size.y
	#read_sign(word)
	if get_parent():
		if get_parent() is MarginContainer:
			container_width = get_parent().rect_size.x 
			rect_size.x = container_width
	pass


func bb_take_out_foreign_letters_params(word=""):
	var language_params=[]
	var kind_params=[]
	var language_short=""
	var kind_short=""
	var original_word=""
	var write_language=false
	var write_kind=false
	for letter in word:
		if letter=="[":
			original_word+=letter
			write_language=true
		elif write_language and int(letter):
			write_language=false
			language_params.append(language_short)
			language_short=""
			write_kind=true
		elif letter=="]":
			write_kind=false
			kind_params.append(kind_short)
			kind_short=""
		if write_language:
			if letter!="[":
				language_short+=letter
		elif write_kind:
			kind_short+=letter
		else:
			if letter!="]":
				original_word+=letter
	return [original_word,language_params,kind_params]


func read_sign(word):
	word_on_screen=word
	word = bb_take_out_foreign_letters_params(word)
	var letter_number = 0
	var foreign_letter=false
	for letter in get_children():
		if letter is TextureRect:
			letter.visible = false
			letter.modulate = Color(1,1,1,1)
			letter.stretch_mode = 4
	if LettersAndNumbers.bb_length(word[0]) > (get_child_count()-2):
		return 

	for letter in word[0]:
		match letter:
			"0":
				get_child(letter_number).texture = LettersAndNumbers.number_0
			"1":
				get_child(letter_number).texture = LettersAndNumbers.number_1
			"2":
				get_child(letter_number).texture = LettersAndNumbers.number_2
			"3":
				get_child(letter_number).texture = LettersAndNumbers.number_3
			"4":
				get_child(letter_number).texture = LettersAndNumbers.number_4
			"5":
				get_child(letter_number).texture = LettersAndNumbers.number_5
			"6":
				get_child(letter_number).texture = LettersAndNumbers.number_6
			"7":
				get_child(letter_number).texture = LettersAndNumbers.number_7
			"8":
				get_child(letter_number).texture = LettersAndNumbers.number_8
			"9":
				get_child(letter_number).texture = LettersAndNumbers.number_9
			"A":
				get_child(letter_number).texture = LettersAndNumbers.letter_A
			"B":
				get_child(letter_number).texture = LettersAndNumbers.letter_B
			"C":
				get_child(letter_number).texture = LettersAndNumbers.letter_C
			"D":
				get_child(letter_number).texture = LettersAndNumbers.letter_D
			"E":
				get_child(letter_number).texture = LettersAndNumbers.letter_E
			"F":
				get_child(letter_number).texture = LettersAndNumbers.letter_F
			"G":
				get_child(letter_number).texture = LettersAndNumbers.letter_G
			"H":
				get_child(letter_number).texture = LettersAndNumbers.letter_H
			"I":
				get_child(letter_number).texture = LettersAndNumbers.letter_I
			"J":
				get_child(letter_number).texture = LettersAndNumbers.letter_J
			"K":
				get_child(letter_number).texture = LettersAndNumbers.letter_K
			"L":
				get_child(letter_number).texture = LettersAndNumbers.letter_L
			"M":
				get_child(letter_number).texture = LettersAndNumbers.letter_M
			"N":
				get_child(letter_number).texture = LettersAndNumbers.letter_N
			"O":
				get_child(letter_number).texture = LettersAndNumbers.letter_O
			"P":
				get_child(letter_number).texture = LettersAndNumbers.letter_P
			"Q":
				get_child(letter_number).texture = LettersAndNumbers.letter_Q
			"R":
				get_child(letter_number).texture = LettersAndNumbers.letter_R
			"S":
				get_child(letter_number).texture = LettersAndNumbers.letter_S
			"T":
				get_child(letter_number).texture = LettersAndNumbers.letter_T
			"U":
				get_child(letter_number).texture = LettersAndNumbers.letter_U
			"V":
				get_child(letter_number).texture = LettersAndNumbers.letter_V
			"W":
				get_child(letter_number).texture = LettersAndNumbers.letter_W
			"X":
				get_child(letter_number).texture = LettersAndNumbers.letter_X
			"Y":
				get_child(letter_number).texture = LettersAndNumbers.letter_Y
			"Z":
				get_child(letter_number).texture = LettersAndNumbers.letter_Z
			"a":
				get_child(letter_number).texture = LettersAndNumbers.letter_a
			"b":
				get_child(letter_number).texture = LettersAndNumbers.letter_b
			"c":
				get_child(letter_number).texture = LettersAndNumbers.letter_c
			"d":
				get_child(letter_number).texture = LettersAndNumbers.letter_d
			"e":
				get_child(letter_number).texture = LettersAndNumbers.letter_e
			"f":
				get_child(letter_number).texture = LettersAndNumbers.letter_f
			"g":
				get_child(letter_number).texture = LettersAndNumbers.letter_g
			"h":
				get_child(letter_number).texture = LettersAndNumbers.letter_h
			"i":
				get_child(letter_number).texture = LettersAndNumbers.letter_i
			"j":
				get_child(letter_number).texture = LettersAndNumbers.letter_j
			"k":
				get_child(letter_number).texture = LettersAndNumbers.letter_k
			"l":
				get_child(letter_number).texture = LettersAndNumbers.letter_l
			"m":
				get_child(letter_number).texture = LettersAndNumbers.letter_m
			"n":
				get_child(letter_number).texture = LettersAndNumbers.letter_n
			"o":
				get_child(letter_number).texture = LettersAndNumbers.letter_o
			"p":
				get_child(letter_number).texture = LettersAndNumbers.letter_p
			"q":
				get_child(letter_number).texture = LettersAndNumbers.letter_q
			"r":
				get_child(letter_number).texture = LettersAndNumbers.letter_r
			"s":
				get_child(letter_number).texture = LettersAndNumbers.letter_s
			"t":
				get_child(letter_number).texture = LettersAndNumbers.letter_t
			"u":
				get_child(letter_number).texture = LettersAndNumbers.letter_u
			"v":
				get_child(letter_number).texture = LettersAndNumbers.letter_v
			"w":
				get_child(letter_number).texture = LettersAndNumbers.letter_w
			"x":
				get_child(letter_number).texture = LettersAndNumbers.letter_x
			"y":
				get_child(letter_number).texture = LettersAndNumbers.letter_y
			"z":
				get_child(letter_number).texture = LettersAndNumbers.letter_z
###############################
#SPECIAL OBJECTS
###############################
			":":
				get_child(letter_number).texture = LettersAndNumbers.colon
			"?":
				get_child(letter_number).texture = LettersAndNumbers.question_mark
			".":
				get_child(letter_number).texture = LettersAndNumbers.dot
			"!":
				get_child(letter_number).texture = LettersAndNumbers.exclamation
			",":
				get_child(letter_number).texture = LettersAndNumbers.comma
			"'":
				get_child(letter_number).texture = LettersAndNumbers.apostrophe
			"-":
				get_child(letter_number).texture = LettersAndNumbers.dash
			"<":
				get_child(letter_number).texture = LettersAndNumbers.greater
			">":
				get_child(letter_number).texture = LettersAndNumbers.lesser
			"/":
				get_child(letter_number).texture = LettersAndNumbers.slash_to_left
			"#":
				get_child(letter_number).texture = LettersAndNumbers.hash_mark
			"%":
				get_child(letter_number).texture = LettersAndNumbers.percent
			" ":
				get_child(letter_number).texture = LettersAndNumbers.letter_empty
				get_child(letter_number).modulate = Color(1,1,1,0)



###############################
#FOREIGN SYMBOLS
###############################

			"[":
				match word[1][0]:

					"CZ":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.cz_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.cz_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.cz_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.cz_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.cz_005
							6:
								get_child(letter_number).texture = LettersAndNumbers.cz_006
							7:
								get_child(letter_number).texture = LettersAndNumbers.cz_007
							8:
								get_child(letter_number).texture = LettersAndNumbers.cz_008
							9:
								get_child(letter_number).texture = LettersAndNumbers.cz_009
							10:
								get_child(letter_number).texture = LettersAndNumbers.cz_010
							11:
								get_child(letter_number).texture = LettersAndNumbers.cz_011
							12:
								get_child(letter_number).texture = LettersAndNumbers.cz_012
							13:
								get_child(letter_number).texture = LettersAndNumbers.cz_013
							14:
								get_child(letter_number).texture = LettersAndNumbers.cz_014
							15:
								get_child(letter_number).texture = LettersAndNumbers.cz_015

					"DE":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.de_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.de_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.de_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.de_004

					"DK":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.dk_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.dk_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.dk_003

					"EE":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.ee_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.ee_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.ee_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.ee_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.ee_005
							6:
								get_child(letter_number).texture = LettersAndNumbers.ee_006

					"ESP":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.esp_001

					"FI":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.fi_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.fi_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.fi_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.fi_004

					"ESP":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.esp_001

					"FR":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.fr_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.fr_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.fr_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.fr_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.fr_005
							6:
								get_child(letter_number).texture = LettersAndNumbers.fr_006
							7:
								get_child(letter_number).texture = LettersAndNumbers.fr_007
							8:
								get_child(letter_number).texture = LettersAndNumbers.fr_008
							9:
								get_child(letter_number).texture = LettersAndNumbers.fr_009
							10:
								get_child(letter_number).texture = LettersAndNumbers.fr_010
							11:
								get_child(letter_number).texture = LettersAndNumbers.fr_011
							12:
								get_child(letter_number).texture = LettersAndNumbers.fr_012
							13:
								get_child(letter_number).texture = LettersAndNumbers.fr_013
							14:
								get_child(letter_number).texture = LettersAndNumbers.fr_014
							15:
								get_child(letter_number).texture = LettersAndNumbers.fr_015
							16:
								get_child(letter_number).texture = LettersAndNumbers.fr_016
							17:
								get_child(letter_number).texture = LettersAndNumbers.fr_017
							18:
								get_child(letter_number).texture = LettersAndNumbers.fr_018
							19:
								get_child(letter_number).texture = LettersAndNumbers.fr_019

					"HR":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.hr_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.hr_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.hr_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.hr_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.hr_005


					"HU":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.hu_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.hu_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.hu_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.hu_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.hu_005
							6:
								get_child(letter_number).texture = LettersAndNumbers.hu_006
							7:
								get_child(letter_number).texture = LettersAndNumbers.hu_007
							8:
								get_child(letter_number).texture = LettersAndNumbers.hu_008
							9:
								get_child(letter_number).texture = LettersAndNumbers.hu_009

					"LT":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.lt_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.lt_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.lt_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.lt_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.lt_005
							6:
								get_child(letter_number).texture = LettersAndNumbers.lt_006
							7:
								get_child(letter_number).texture = LettersAndNumbers.lt_007
							8:
								get_child(letter_number).texture = LettersAndNumbers.lt_008
							9:
								get_child(letter_number).texture = LettersAndNumbers.lt_009

					"LV":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.lv_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.lv_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.lv_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.lv_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.lv_005
							6:
								get_child(letter_number).texture = LettersAndNumbers.lv_006
							7:
								get_child(letter_number).texture = LettersAndNumbers.lv_007

					"NO":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.dk_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.dk_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.dk_003


					"PL":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.pl_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.pl_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.pl_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.pl_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.pl_005
							6:
								get_child(letter_number).texture = LettersAndNumbers.pl_006
							7:
								get_child(letter_number).texture = LettersAndNumbers.pl_007
							8:
								get_child(letter_number).texture = LettersAndNumbers.pl_008
							9:
								get_child(letter_number).texture = LettersAndNumbers.pl_009

					"PT":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.pt_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.pt_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.pt_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.pt_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.pt_005
							6:
								get_child(letter_number).texture = LettersAndNumbers.pt_006
							7:
								get_child(letter_number).texture = LettersAndNumbers.pt_007
							8:
								get_child(letter_number).texture = LettersAndNumbers.pt_008
							9:
								get_child(letter_number).texture = LettersAndNumbers.pt_009
							10:
								get_child(letter_number).texture = LettersAndNumbers.pt_010
							11:
								get_child(letter_number).texture = LettersAndNumbers.pt_011
							12:
								get_child(letter_number).texture = LettersAndNumbers.pt_012
							13:
								get_child(letter_number).texture = LettersAndNumbers.pt_013

					"RO":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.ro_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.ro_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.ro_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.ro_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.ro_005

					"SE":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.se_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.se_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.se_003

					"SK":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.sk_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.sk_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.sk_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.sk_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.sk_005
							6:
								get_child(letter_number).texture = LettersAndNumbers.sk_006
							7:
								get_child(letter_number).texture = LettersAndNumbers.sk_007
							8:
								get_child(letter_number).texture = LettersAndNumbers.sk_008
							9:
								get_child(letter_number).texture = LettersAndNumbers.sk_009
							10:
								get_child(letter_number).texture = LettersAndNumbers.sk_010
							11:
								get_child(letter_number).texture = LettersAndNumbers.sk_011
							12:
								get_child(letter_number).texture = LettersAndNumbers.sk_012
							13:
								get_child(letter_number).texture = LettersAndNumbers.sk_013
							14:
								get_child(letter_number).texture = LettersAndNumbers.sk_014
							15:
								get_child(letter_number).texture = LettersAndNumbers.sk_015
							16:
								get_child(letter_number).texture = LettersAndNumbers.sk_016

					"SL":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.sl_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.sl_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.sl_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.sl_004
							5:
								get_child(letter_number).texture = LettersAndNumbers.sl_005
							6:
								get_child(letter_number).texture = LettersAndNumbers.sl_006
							7:
								get_child(letter_number).texture = LettersAndNumbers.sl_007
							8:
								get_child(letter_number).texture = LettersAndNumbers.sl_008
							9:
								get_child(letter_number).texture = LettersAndNumbers.sl_009
							10:
								get_child(letter_number).texture = LettersAndNumbers.sl_010
							11:
								get_child(letter_number).texture = LettersAndNumbers.sl_011
							12:
								get_child(letter_number).texture = LettersAndNumbers.sl_012
							13:
								get_child(letter_number).texture = LettersAndNumbers.sl_013
							14:
								get_child(letter_number).texture = LettersAndNumbers.sl_014
							15:
								get_child(letter_number).texture = LettersAndNumbers.sl_015
							16:
								get_child(letter_number).texture = LettersAndNumbers.sl_016

					"TR":
						match int(word[2][0]):
							1:
								get_child(letter_number).texture = LettersAndNumbers.tr_001
							2:
								get_child(letter_number).texture = LettersAndNumbers.tr_002
							3:
								get_child(letter_number).texture = LettersAndNumbers.tr_003
							4:
								get_child(letter_number).texture = LettersAndNumbers.tr_004


				word[1].remove(0)
				word[2].remove(0)

		get_child(letter_number).visible = true
		letter_number += 1



	if get_parent() is MarginContainer:
		yield(get_tree(),"idle_frame")
		var word_length  = word.length() * _letter_hight * texture_size.x/texture_size.y
		var margin = (container_width - word_length)/2
		match centred:
			true:
				get_parent().set("custom_constants/margin_left", margin)
				get_parent().set("custom_constants/margin_right", margin)
				set("margin_left", 0)
				set("margin_right", container_width)
			false:
				get_parent().set("custom_constants/margin_left", 0)
				get_parent().set("custom_constants/margin_right", 2*margin)
