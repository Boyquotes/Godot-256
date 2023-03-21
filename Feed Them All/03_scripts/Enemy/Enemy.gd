extends RigidBody2D

signal base_was_hitted

var explosion_package = load("res://02_scenes/Explosion.tscn")
var bite_package = load("res://02_scenes/HitBase.tscn")

### KINDS OF ENEMIES ###
enum ENEMY {
		BLUE,
		YELLOW,
		GREEN
}

enum ENEMY_SIZE{
		SMALL,
		MEDIUM,
		LARGE
}

var kind_of_enemy = ENEMY.BLUE setget set_kind_of_enemy
var size_of_enemy =  ENEMY_SIZE.SMALL setget set_size_of_enemy
var velocity = Vector2.ZERO
var bubble_position = Vector2.ZERO
var hp = 2
var max_hp = 2 
var left_x = 0
var right_x = 0
var left_y = -50
var right_y = -50
var wait_time = 2
var angle_up
var angle_down 
var waiting_for_attack
var pending_yield
var washed_beacuse_of_new_game_started = false
var number_of_aproaching_units = 0
var tutorial_mode = false
var tutorial_phase = 0


var eated_unit 
var collision_layer_from_unit

onready var wait_for_attack_timer = $WaitForAttackTimer
onready var get_main_scene = get_tree().get_root().get_node("Main")
onready var enemy_body = $EnemyBody
onready var enemy_eyes = $EnemyEyes
onready var enemy_head_shape = $EnemyHead/Shape
onready var pointer_anim = $Pointer/PointerAnimPlayer
onready var tween = $Tween


#### STATE MACHINE ####
onready var state_machine = $StateMachine

#### ANIMATIONS ####
onready var anim_tree = $AnimTree

#### SET GET FUNCTIONS ####
func set_kind_of_enemy(value: int):
	match value:
		0:
			kind_of_enemy = ENEMY.BLUE
			enemy_body.modulate = Color(0,0,1,1)
			#$Pointer.modulate = Color(0,0,1,1)
			get_node("EnemyHead").set_collision_mask(23)
		1:
			kind_of_enemy = ENEMY.YELLOW
			enemy_body.modulate = Color(1,1,0,1)
			#$Pointer.modulate = Color(1,1,0,1)
			get_node("EnemyHead").set_collision_mask(39)
		2:
			kind_of_enemy = ENEMY.GREEN
			enemy_body.modulate = Color(0,1,0,1)
			#$Pointer.modulate = Color(0,1,0,1)
			get_node("EnemyHead").set_collision_mask(71)

func set_size_of_enemy(value: int):
	match value:
		0:
			size_of_enemy = ENEMY_SIZE.SMALL
			enemy_eyes.modulate = Color(0.8,0.8,0.8,1)
			set_new_scale(0.15)
			
			hp = 1
			max_hp = 1
		1:
			size_of_enemy = ENEMY_SIZE.MEDIUM
			enemy_eyes.modulate = Color(1,0.5,0.5,1)
			set_new_scale(0.2)
			hp = 2
			max_hp = 2
		2:
			size_of_enemy = ENEMY_SIZE.LARGE
			enemy_eyes.modulate = Color(1,0,0,1)
			set_new_scale(0.3)
			hp = 3
			max_hp = 3
	enemy_body.scale *=4
	enemy_eyes.position.y = -160 * enemy_eyes.scale.y
	enemy_eyes.scale *=2



#### MAIN FUNCTIONS ####
func _ready():
	get_main_scene.get_node("Enemies").set_number_of_active_enemies(+1)
	connect("base_was_hitted",get_main_scene,"there_was_a_hit")
	randomize()
	match tutorial_mode:
		false:
			start_settings(DifficultyScaler.difficulty_level)
			pick_random_kind_of_enemy()
			pick_random_size()
			take_collision_layer_from_unit()
			pick_random_velocity(left_x,right_x,left_y,right_y)
		true:
			all_settings_for_tuto()
			take_collision_layer_from_unit()
	waiting_for_attack = wait_befor_attack(wait_time)


func _physics_process(delta):
	rotation = get_linear_velocity().normalized().angle()+deg2rad(90)
	pass


#### SIGNALS ####

func _on_Enemy_1_body_entered(body):
	if body.collision_layer == 1:
		if washed_beacuse_of_new_game_started:
			queue_free()
		else:
			if tutorial_mode:
				get_main_scene.get_node("TUTORIAL").emit_signal("show_next_advice",get_main_scene.get_node("TUTORIAL").tutorial_step)
			bite(self,hp)
			emit_signal("base_was_hitted",kind_of_enemy,hp)
			get_main_scene.check_max_number_of_unit()
			get_main_scene.difficulty_checker()
			queue_free()
	if body.collision_layer == 4:
		velocity = linear_velocity
		pass

func _on_EnemyHead_area_entered(area):
	var unit = area.get_parent()
	if state_machine._current_state.name == "PreparingState":
		if unit is KinematicBody2D and area.name == "Mouth":
			if unit.kind_of_unit == kind_of_enemy:
				unit.state_machine.change_state_to("BounceAwayState")
	elif not state_machine._current_state.name == "EatingState":
		var unit_state = unit.state_machine._current_state.name
		if unit is KinematicBody2D and area.name == "Mouth" and not unit_state=="EatedState":
			if unit.kind_of_unit == kind_of_enemy:
				unit.touched_by_enemy = true
				unit.name_of_touching_enemy = self
				set_linear_velocity(Vector2.ZERO)
				unit.state_machine.change_state_to("EatedState")
				state_machine.change_state_to("EatingState")

func _on_Enemy_tree_exiting():
	get_parent().set_number_of_active_enemies(-1)

func _on_UnitSensor_area_entered(area):
	var unit = area.get_parent()
	if state_machine._current_state.name == "PreparingState":
		if unit is KinematicBody2D and area.name == "Mouth":
			if unit.kind_of_unit == kind_of_enemy:
				pass
	elif not state_machine._current_state.name == "EatingState":
		var unit_state = unit.state_machine._current_state.name
		if unit is KinematicBody2D and area.name == "Mouth" and not unit_state=="EatedState":
			if unit.kind_of_unit == kind_of_enemy:
				number_of_aproaching_units += 1
				tween.interpolate_method(self, "set_linear_velocity",
				 velocity, velocity.normalized()*20, 0.1,
				 Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
				#set_linear_velocity(velocity.normalized()*20)

func _on_UnitSensor_area_exited(area):
	var unit = area.get_parent()
	var unit_state = unit.state_machine._current_state.name
	var state = state_machine._current_state.name
	if unit is KinematicBody2D and area.name == "Mouth":
		if unit.kind_of_unit == kind_of_enemy:
			number_of_aproaching_units -= 1
			if number_of_aproaching_units <= 0:
				if not (state == "DieingState" or state =="EatingState"):
					#set_linear_velocity(velocity)
					tween.interpolate_property(self, "linear_velocity",
					 get_linear_velocity(), velocity, 0.2,
					 Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					tween.start()

### OTHER FUNCTIONS ####

func all_settings_for_tuto():
	match tutorial_phase:
		0:
			set_kind_of_enemy(0)
			set_size_of_enemy(0)
			velocity=Vector2(0,-50)
		1:
			set_kind_of_enemy(0)
			set_size_of_enemy(0)
			velocity=Vector2(0,-50)
		2:
			set_kind_of_enemy(0)
			set_size_of_enemy(1)
			velocity=Vector2(0,-50)
		3:
			set_kind_of_enemy(0)
			set_size_of_enemy(2)
			velocity=Vector2(0,-50)
		4:
			set_kind_of_enemy(2)
			set_size_of_enemy(0)
			velocity=Vector2(0,-50)

func start_settings(value):
	match get_main_scene.difficulty_mode:
		0:
			left_x = max((0 - (value-1) * 0.1),-100)
			right_x = min((0 + (value-1) * 0.1),100)
			left_y = max((-25 - value * 0.1),-150)
			right_y =  max((-55 - value * 0.1),-200)
			wait_time = max((5 - value * 0.005),3)
		1:
			left_x = max((-50 - (value-1) * 0.3),-200)
			right_x = min((50 + (value-1) * 0.3),200)
			left_y = max((-25 - value * 0.3),-175)
			right_y =  max((-55 - value * 0.3),-225)
			wait_time = max((5 - value * 0.007),2)
		2:
			left_x = max((-100 - (value-1) * 0.5),-300)
			right_x = min((100 + (value-1) * 0.5),300)
			left_y = max((-25 - value * 0.5),-225)
			right_y =  max((-55 - value * 0.5),-275)
			wait_time = max((5 - value * 0.01),1)



func pick_random_kind_of_enemy():
	randomize()
#	var a = get_main_scene.avaible_units[0]+get_main_scene.units_in_battle[0]+1
#	var b = get_main_scene.avaible_units[1]+get_main_scene.units_in_battle[1]+1
#	var c = get_main_scene.avaible_units[2]+get_main_scene.units_in_battle[2]+1
	var a = 33
	var b = 33
	var c = 33
	if a+b+c != 0:
		var rand_integ = randi()%(a+b+c)
		if rand_integ>=0 and rand_integ<a:
			set_kind_of_enemy(0)
		if rand_integ>=a and rand_integ<(a+b):
			set_kind_of_enemy(1)
		if rand_integ>=(a+b) and rand_integ<(a+b+c):
			set_kind_of_enemy(2)

func pick_random_size():
	randomize()
	var rand_integ = randi()%100
	match get_main_scene.difficulty_mode:
		0:
			pick_random_size_for_easy_mode(rand_integ)
		1:
			pick_random_size_for_medium_mode(rand_integ)
		2:
			pick_random_size_for_hard_mode(rand_integ)



func pick_random_velocity(value_1,value_2,value_3,value_4):
	randomize()
	var x_atack_vector = rand_range(value_1,value_2)
	randomize()
	var y_atack_vector = rand_range(value_3,value_4)
	velocity=(Vector2(x_atack_vector,y_atack_vector))

func set_new_scale(scale):
	if self is RigidBody2D:
		for child in self.get_children():
			if child.has_method("get_scale"):
#				if child.name =="EnemyEyes":
#					child.set_scale(get_scale() * scale *0.5)
#				else:
				child.set_scale(get_scale() * scale)

func wait_befor_attack(value):
	enemy_body.visible = true
	apply_impulse(Vector2.ZERO,velocity.normalized()*300)
	set_linear_damp(4)
	var current_velocity = get_linear_velocity()
	wait_for_attack_timer.set_wait_time(value)
	if current_velocity == Vector2.ZERO:
		wait_for_attack_timer.start()
		#var pending_yield = yield(wait_for_attack_timer,"timeout")
		pending_yield = yield(wait_for_attack_timer,"timeout")
		if (pending_yield and pending_yield==10):
			wait_for_attack_timer.stop()
			return
		if not hp <=0 and not tutorial_mode:
			state_machine.change_state_to("SwimmingState")
		elif tutorial_mode:
			state_machine.change_state_to("TutorialState")



func take_collision_layer_from_unit():
	match kind_of_enemy:
		0:
			collision_layer_from_unit = 16
		1:
			collision_layer_from_unit = 32
		2:
			collision_layer_from_unit = 64

func make_perpedicular(vec:Vector2):
	var new_vector:Vector2
	new_vector.x = - vec.x
	new_vector.y = vec.y
	return new_vector


func pick_random_size_for_easy_mode(rand_integ):
	match DifficultyScaler.difficulty_level:
		1:
			set_size_of_enemy(0)
		2:
			if rand_integ>=0 and rand_integ<80:
				set_size_of_enemy(0)
			elif (rand_integ>=80 and rand_integ<100) and get_main_scene.check_overall_number_of_specific_unit(kind_of_enemy)>=2:
				set_size_of_enemy(1)
			else:
				set_size_of_enemy(0)
		_:
			if rand_integ>=0 and rand_integ<80:
				set_size_of_enemy(0)
			elif (rand_integ>=80 and rand_integ<95) and get_main_scene.check_overall_number_of_specific_unit(kind_of_enemy)>=2:
				set_size_of_enemy(1)
			elif (rand_integ>=95 and rand_integ<100) and get_main_scene.check_overall_number_of_specific_unit(kind_of_enemy)>=3:
				set_size_of_enemy(2)
			else:
				set_size_of_enemy(0)

func pick_random_size_for_medium_mode(rand_integ):
	match DifficultyScaler.difficulty_level:
		1:
			set_size_of_enemy(0)
		2:
			if rand_integ>=0 and rand_integ<50:
				set_size_of_enemy(0)
			elif (rand_integ>=50 and rand_integ<100) and get_main_scene.check_overall_number_of_specific_unit(kind_of_enemy)>=2:
				set_size_of_enemy(1)
			else:
				set_size_of_enemy(0)
		_:
			if rand_integ>=0 and rand_integ<50:
				set_size_of_enemy(0)
			elif (rand_integ>=50 and rand_integ<80) and get_main_scene.check_overall_number_of_specific_unit(kind_of_enemy)>=2:
				set_size_of_enemy(1)
			elif (rand_integ>=80 and rand_integ<100) and get_main_scene.check_overall_number_of_specific_unit(kind_of_enemy)>=3:
				set_size_of_enemy(2)
			else:
				set_size_of_enemy(0)


func pick_random_size_for_hard_mode(rand_integ):
	match DifficultyScaler.difficulty_level:
		1:
			set_size_of_enemy(0)
		2:
			if rand_integ>=0 and rand_integ<30:
				set_size_of_enemy(0)
			elif (rand_integ>=30 and rand_integ<100) and get_main_scene.check_overall_number_of_specific_unit(kind_of_enemy)>=2:
				set_size_of_enemy(1)
			else:
				set_size_of_enemy(0)
		_:
			if rand_integ>=0 and rand_integ<30:
				set_size_of_enemy(0)
			elif (rand_integ>=30 and rand_integ<70) and get_main_scene.check_overall_number_of_specific_unit(kind_of_enemy)>=2:
				set_size_of_enemy(1)
			elif (rand_integ>=70 and rand_integ<100) and get_main_scene.check_overall_number_of_specific_unit(kind_of_enemy)>=3:
				set_size_of_enemy(2)
			else:
				set_size_of_enemy(0)


func bite(actor,bite_power):
	var bite = actor.bite_package.instance()
	match get_main_scene.difficulty_mode:
		0:
			pass
		_:
			bite.setup(bite_power)
	actor.get_main_scene.get_node("Explosions").add_child(bite)
	bite.scale = Vector2(2,2)
	match actor.kind_of_enemy:
		0:
			bite.position = Vector2(26,70)
		1:
			bite.position = Vector2(185,70)
		2:
			bite.position = Vector2(350,70)










