extends KinematicBody2D

### KINDS_OF_UNITS ###
enum UNIT {
	BLUE,
	YELLOW,
	GREEN
}

onready var body_collision_shape = $Body/BodyShape
onready var frame = $Frame
onready var get_main_scene = get_tree().get_root().get_node("Main")
onready var timer_in_battle = $Timer_in_battle_state
onready var timer2 = $Timer_2

const DISTANCE_THRESHOLD: = 1.0 

onready var target_position
onready var occupied_rotation = rotation

var look_at_vector = Vector2.ZERO
var _velocity: = Vector2.ZERO
var direction_for_move_away = Vector2.ZERO
var waiting_time_befor_float_away = 15 setget set_wait_time_for_timer_in_battle

#onready var unit_start_pos = Vector2.ZERO
#onready var unit_in_front_of_box_pos = Vector2(10,10)
onready var unit_start_pos 
onready var unit_in_front_of_box_pos 

var list_of_overlapping_units = []
var list_of_overlapping_enemies = []
var number_of_overlapping_units = 0
var number_of_overlapping_enemies = 0

var selected = false setget set_selected
var kind_of_unit = UNIT.BLUE setget set_kind_of_unit
var touched_by_enemy = false
var name_of_touching_enemy

var tutorial_mode = false
var tutorial_phase = 0

var pending_eyes_yield
var pending_thorn_yield

#### STATE MACHINE ####
onready var state_machine = $StateMachine

#### ANIAMATIONS ####
onready var anim_tree = $AnimTree
onready var tween = $Tween
onready var tween2 = $Tween2

var unique_waiting:Animation = Animation.new()
var unique_body_waiting:Animation = Animation.new()
var cond_for_body_anim_occurrence
var cond_for_eyes_anim_occurrence
var kit_of_eyes_anims:Array = []
var kit_of_eyes_anims_dur:Array = []
var body_anim_occurance = 1.0

var minus_package = load("res://02_scenes/HitBase.tscn") #the same package in enemy under name bite_package

#### SET GET FUNCTIONS ####
func set_selected(value):
	if selected != value:
		selected = value
		frame.visible = value
	if value and tutorial_mode:
		get_main_scene.get_node("TUTORIAL").emit_signal("show_next_advice",get_main_scene.get_node("TUTORIAL").tutorial_step)

func set_kind_of_unit(value: int):
	match value:
		0:
			kind_of_unit = UNIT.BLUE
		1:
			kind_of_unit = UNIT.YELLOW
		2:
			kind_of_unit = UNIT.GREEN


func set_wait_time_for_timer_in_battle(value):
	match get_main_scene.difficulty_mode:
		0:
			waiting_time_befor_float_away = max(7,15-value*0.1)
		1:
			waiting_time_befor_float_away = max(6,10-value*0.1)
		2:
			waiting_time_befor_float_away = max(5,8-value*0.1)

#### MAIN FUNCTIONS ####
func _ready():
	position = unit_start_pos
	$EyesAnim.add_animation("unique_waiting",unique_waiting)
	$BodyAnim.add_animation("unique_body_waiting",unique_body_waiting)
	set_wait_time_for_timer_in_battle(DifficultyScaler.difficulty_level)
func _input(event):
	pass


#### SIGNALS ####
func _on_Mouth_body_entered(body):
	if body.collision_layer == 1:
		cancel_setting_target()
		back_to_base()

func _on_Body_area_entered(area):
	var q = area.collision_layer
	if q == 2 or q == 128: # 2 - Enemy base / 128 BacktoBase (near Mirrors)
		state_machine.change_state_to("SendToBaseState2")
	if q == 256: #Vacuum
		pass
	if q==512 and area.name =="Body": #Unit Body
		var state = state_machine._current_state.name
		if area.get_parent().state_machine._current_state.name == "EatedState":
			state_machine.change_state_to("BounceAwayState")
		elif not (state=="MovingState" or state=="EatedState"):
			state_machine.change_state_to("MovingAwayState")
			pass
	if q==8 and area.name =="EnemySides": 
		var state = state_machine._current_state.name
		if not (state=="EatedState" or state=="DieingState"):
			state_machine.change_state_to("MovingAwayState")

func _on_Body_area_exited(area):
	var q = area.collision_layer
	if (q==16 or q==32 or q==64) and area.name =="Body":
		number_of_overlapping_units -= 1
		list_of_overlapping_units.erase(area.get_parent())
		if number_of_overlapping_units <= 0:
			number_of_overlapping_units = 0
	if (q==8) and area.name =="EnemySides":
		number_of_overlapping_enemies -= 1
		list_of_overlapping_enemies.erase(area.get_parent())
		if number_of_overlapping_enemies <= 0:
			number_of_overlapping_enemies = 0

func _on_Timer_in_battle_state_timeout():
	state_machine.change_state_to("FloatingAwayState")

### OTHER FUNCTIONS ####
func cancel_setting_target():
	var x = get_main_scene.selected_units.find(self)
	if x != -1:
		if not SettingTarget.target.empty():
			SettingTarget.target[x].anim.play("fade_out")
			SettingTarget.target.remove(x)
		get_main_scene.selected_units.remove(x)
	set_selected(false)

func back_to_base():
	#print("back to base" + "   " + self.name)
	get_main_scene._unit_come_back_to_base(kind_of_unit)
	get_main_scene._take_of_unit_from_battle(kind_of_unit)
	queue_free()

func disable_collision_areas():
	var mouth = get_node("Mouth")
	var body = get_node("Body")
	mouth.set_deferred("monitoring", false)
	mouth.set_deferred("monitorable", false)
	body.set_deferred("monitoring", false)
	body.set_deferred("monitorable", false)

func activate_collision_areas():
	var mouth = get_node("Mouth")
	var body = get_node("Body")
	mouth.set_deferred("monitoring", true)
	mouth.set_deferred("monitorable", true)
	body.set_deferred("monitoring", true)
	body.set_deferred("monitorable", true)

#func type_start_and_end_for_animation(start_vec,end_vec):
#	var animation:Animation = $AnimPlayer.get_animation("Unit_out_of_box")
#	animation.set_length(2)

func type_start_and_end_for_animation(start_vec,end_vec,type_of_unit,time_factor):
	randomize()
	var rand_angle = rand_range(rand_range(-500,-180),rand_range(180,500))
	var between_vec
	match type_of_unit:
		0:
			between_vec = Vector2(80,70)
		1:
			between_vec = Vector2(245,70)
		2:
			between_vec = Vector2(400,70)
	
	tween.interpolate_property(self, "rotation_degrees",
		0, rand_angle, 0.6/time_factor,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "position",
		start_vec, between_vec, 0.6/time_factor,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")

	tween.interpolate_property(self, "position",
		between_vec, end_vec, 0.4,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.interpolate_property(self, "scale",
		Vector2(0.4,0.4), Vector2(2,2), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween2.start()
	yield(tween2,"tween_completed")
	get_node("StateMachine/TakingOutOfBoxState/TakingOutOfBox").make_fully_visible()
#	get_node("StateMachine/TakingOutOfBoxState/TakingOutOfBox").set_color_of_mug_for_animation()

	tween2.interpolate_property(self, "scale",
		Vector2(2,2), Vector2(1,1) , 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.start()

	yield(tween2,"tween_completed")
	get_node("StateMachine/TakingOutOfBoxState/TakingOutOfBox").change_to_in_battle_state()
	$Body.set_collision_mask(1786)

func go_out_from_belly(pos):
	randomize()
	var rand_dir = Vector2(rand_range(-1,1),rand_range(-1,1)).normalized()
	tween.interpolate_property(self, "scale",
		Vector2(1,1), Vector2(2,2) , 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "position",
		pos, (pos+rand_dir*30), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")
	tween2.interpolate_property(self, "scale",
		Vector2(2,2), Vector2(1,1) , 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.interpolate_property(self, "position",
		(pos+rand_dir*30), (pos+rand_dir*60), 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.start()
	yield(tween2,"tween_completed")
	get_node("StateMachine/TakingOutOfBoxState/TakingOutOfBox").change_to_floating_away_state()
#	get_node("StateMachine/TakingOutOfBoxState/TakingOutOfBox").change_to_in_battle_state()
	$Body.set_collision_mask(1786)


func create_eyes_anim():
	if cond_for_eyes_anim_occurrence>=70 and cond_for_eyes_anim_occurrence<100:
		return
	unique_waiting.clear()
	var track_index_1 = unique_waiting.add_track(Animation.TYPE_VALUE,0)
	unique_waiting.track_set_path(0, "Eyes:animation")
	unique_waiting.value_track_set_update_mode (0,Animation.UPDATE_DISCRETE)
	unique_waiting.length = 3.0
	var track_time = 0.0
	for i in range(2):
		unique_waiting.track_insert_key(0, track_time, kit_of_eyes_anims[i])
		track_time += kit_of_eyes_anims_dur[i]
	create_body_anim()
	$EyesAnim.current_animation = "unique_waiting"
	$EyesAnim.play("unique_waiting")


func create_body_anim():
	if cond_for_body_anim_occurrence>=30 and cond_for_body_anim_occurrence<100:
		return
	unique_body_waiting.clear()
	var track_index_1 = unique_body_waiting.add_track(Animation.TYPE_VALUE,0)
	unique_body_waiting.track_set_path(0, "Unit:animation")
	unique_body_waiting.value_track_set_update_mode (0,Animation.UPDATE_DISCRETE)
	unique_body_waiting.length = 3.0
	unique_body_waiting.track_insert_key(0, body_anim_occurance, "Idle_with_thorns")
	unique_body_waiting.track_insert_key(0, body_anim_occurance+0.2, "Idle")
	unique_body_waiting.track_insert_key(0, body_anim_occurance+0.4, "Idle_with_thorns")
	unique_body_waiting.track_insert_key(0, body_anim_occurance+0.6, "Idle")
	$BodyAnim.current_animation = "unique_body_waiting"
	$BodyAnim.play("unique_body_waiting")

func _to_draw_animation():
	kit_of_eyes_anims.clear()
	kit_of_eyes_anims_dur.clear()
	randomize()
	cond_for_body_anim_occurrence = randi() % 100
	cond_for_eyes_anim_occurrence = randi() % 100
	body_anim_occurance = (rand_range(0.8,2))
	for i in range(4):
		kit_of_eyes_anims.append(str(randi() % 5 +1))
		kit_of_eyes_anims_dur.append(rand_range(0.2,1))

func bounce_away(dir):
	disable_collision_areas()
	tween.interpolate_property(self, "scale",
		Vector2(1,1), Vector2(1.5,1.5) , 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "position",
		global_position,global_position+dir*30, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")
	tween.interpolate_property(self, "scale",
		Vector2(1.5,1.5), Vector2(1,1) , 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "position",
		global_position+dir*30, global_position+dir*60, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")
	activate_collision_areas()
	state_machine.change_state_to("MovingAwayState")


func show_unit_lost(x_coor,y_coor):
	var minus = minus_package.instance()
	get_main_scene.get_node("Explosions").add_child(minus)
	minus.scale = Vector2(2,2)
	minus.position = Vector2(x_coor,y_coor)

func setup_start_position(pos = Vector2(0,0)):
	unit_start_pos = pos
