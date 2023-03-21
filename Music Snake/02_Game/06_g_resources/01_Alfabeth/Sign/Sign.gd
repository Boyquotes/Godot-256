extends HBoxContainer

export var word:=""
export var texture_size = Vector2(156,256)
export (bool) var centred = true

var _letter_hight
var word_on_screen:= ""
var container_width = 100.0

func _ready():
	_letter_hight = rect_size.y
	read_sign(word)
	if get_parent():
		if get_parent() is MarginContainer:
			container_width = get_parent().rect_size.x 
			rect_size.x = container_width
	pass


func read_sign(word):
	word_on_screen=word
	var letter_number = 0
	for letter in get_children():
		if letter is TextureRect:
			letter.visible = false
			letter.modulate = Color(1,1,1,1)
			letter.stretch_mode = 4
	if word.length() > (get_child_count()-2):
		return 
	for letter in word:
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

			":":
				get_child(letter_number).texture = LettersAndNumbers.colon
			"||":
				get_child(letter_number).texture = LettersAndNumbers.pause
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
			" ":
				get_child(letter_number).texture = LettersAndNumbers.letter_empty
				get_child(letter_number).modulate = Color(1,1,1,0)
		get_child(letter_number).visible = true
		letter_number += 1

	if get_parent() is MarginContainer:
		yield(get_tree(),"idle_frame")
		var word_length  = word.length() * _letter_hight * texture_size.x/texture_size.y

		var margin = (container_width - word_length)/2


		match centred:
			true:
#				set("margin_left", -margin)
#				set("margin_right", container_width+margin)

				get_parent().set("custom_constants/margin_left", margin)
				get_parent().set("custom_constants/margin_right", margin)
				set("margin_left", 0)
				set("margin_right", container_width)

			false:
				get_parent().set("custom_constants/margin_left", 0)
				get_parent().set("custom_constants/margin_right", 2*margin)


#		container.mar

#	var separation = -(rect_size.x - width_for_separation*rect_size.y/texture_size * word.length())
#	print("separation: "+" , "+str(get_parent().name) )
#	print("separation: "+" , "+ word )
#	print("width_for_separation: "+" , "+str(width_for_separation) )
#	print("texture_size: "+" , "+str(texture_size) )
#	print("separation: "+str(separation)+" , "+ str(rect_size.x)+" , "+str(rect_size.y)+" , "+ str(word.length()))
#	print("separation: "+" , "+str(get_parent().name))
#	set("custom_constants/separation", separation)




#func prepare_size(word):
#	rect_size.x = get_parent().rect_size.x / rect_scale.x
#	rect_position.y = get_parent().rect_size.y/2-256*rect_scale.x/2
#	print(margin_right - margin_left)
#	print( str(rect_size.x) +" , "+str(width_for_separation) +" , "+str(word.length()) +" , ")
#	var separation = -(rect_size.x - width_for_separation*rect_size.y/texture_size * word.length())
#	set("custom_constants/separation", separation)
#	pass



