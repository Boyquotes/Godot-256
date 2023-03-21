## NUMBERS ###

extends Node

var number_0 = preload("res://01_Assests/Fonts/Alfabeth/0.png")
var number_1 = preload("res://01_Assests/Fonts/Alfabeth/1.png")
var number_2 = preload("res://01_Assests/Fonts/Alfabeth/2.png")
var number_3 = preload("res://01_Assests/Fonts/Alfabeth/3.png")
var number_4 = preload("res://01_Assests/Fonts/Alfabeth/4.png")
var number_5 = preload("res://01_Assests/Fonts/Alfabeth/5.png")
var number_6 = preload("res://01_Assests/Fonts/Alfabeth/6.png")
var number_7 = preload("res://01_Assests/Fonts/Alfabeth/7.png")
var number_8 = preload("res://01_Assests/Fonts/Alfabeth/8.png")
var number_9 = preload("res://01_Assests/Fonts/Alfabeth/9.png")


func take_number(number):
	var nr = number_0
	match number:
		"0":
			nr = number_0
		"1":
			nr = number_1
		"2":
			nr = number_2
		"3":
			nr = number_3
		"4":
			nr = number_4
		"5":
			nr = number_5
		"6":
			nr = number_6
		"7":
			nr = number_7
		"8":
			nr = number_8
		"9":
			nr = number_9
	return nr
