extends Sprite

var empty_sprite = preload("res://02_Game/03_g_assets/Drum_kit/empty.png")

var drum_bass_sprite = preload("res://02_Game/03_g_assets/Drum_kit/drum_bass.png")
var snare_drum_sprite = preload("res://02_Game/03_g_assets/Drum_kit/snare_drum.png")
var sticks_sprite = preload("res://02_Game/03_g_assets/Drum_kit/sticks.png")
var tom_tom_1_sprite = preload("res://02_Game/03_g_assets/Drum_kit/tom_tom_1.png")
var tom_tom_2_sprite = preload("res://02_Game/03_g_assets/Drum_kit/tom_tom_2.png")

var c_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/C.png")
var d_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/D.png")
var e_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/E.png")
var f_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/F.png")
var g_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/G.png")
var a_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/A.png")
var b_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/B.png")


var godot_sprite = preload("res://icon.png")

var main_type = ""
var type_of_apple = 0 setget set_type_of_apple

func _ready():
	pass # Replace with function body.

func start_func(type):
	main_type = type


func set_type_of_apple(value):
	match main_type:
		"Drum_kit":
			match value:
				0:
					type_of_apple = 0
					$Sprite.texture=empty_sprite
				1:
					type_of_apple = 1
					$Sprite.texture=drum_bass_sprite
				2:
					type_of_apple = 2
					$Sprite.texture=snare_drum_sprite
				3:
					type_of_apple = 3
					$Sprite.texture=sticks_sprite
				4:
					type_of_apple = 4
					$Sprite.texture=tom_tom_1_sprite
				5:
					type_of_apple = 5
					$Sprite.texture=tom_tom_2_sprite
		"Piano":
#			texture = godot_sprite
			match value:
				0:
					type_of_apple = 0
					$Sprite.texture=empty_sprite
				1:
					type_of_apple = 1
					$Sprite.texture=c_sprite
				2:
					type_of_apple = 2
					$Sprite.texture=d_sprite
				3:
					type_of_apple = 3
					$Sprite.texture=e_sprite
				4:
					type_of_apple = 4
					$Sprite.texture=f_sprite
				5:
					type_of_apple = 5
					$Sprite.texture=g_sprite
				6:
					type_of_apple = 6
					$Sprite.texture=a_sprite
				7:
					type_of_apple = 7
					$Sprite.texture=b_sprite
				8:
					type_of_apple = 8
					$Sprite.texture=c_sprite
					modulate = Color(1,0,0,1)
		"Bass":
#			texture = godot_sprite
			match value:
				0:
					type_of_apple = 0
					$Sprite.texture=empty_sprite
				1:
					type_of_apple = 1
					$Sprite.texture=c_sprite
				2:
					type_of_apple = 2
					$Sprite.texture=d_sprite
				3:
					type_of_apple = 3
					$Sprite.texture=e_sprite
				4:
					type_of_apple = 4
					$Sprite.texture=f_sprite
				5:
					type_of_apple = 5
					$Sprite.texture=g_sprite
				6:
					type_of_apple = 6
					$Sprite.texture=a_sprite
				7:
					type_of_apple = 7
					$Sprite.texture=b_sprite
				8:
					type_of_apple = 8
					$Sprite.texture=c_sprite
					modulate = Color(1,0,0,1)

func _on_Area2D_area_entered(area):
	if area.get_node("..").name=="Head":
#		print("snake ate me!")
		queue_free()
