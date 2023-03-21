extends "res://03_scripts/StateMachine/PlatformCommand.gd"

var float_vel = Vector2(100,0)
var dead = false

func _unhandled_input(event):
	pass

func _physics_process(delta):
	if dead:
		actor.global_position -= float_vel*delta
	if actor.global_position.x <= -400:
		actor.queue_free()

func _start_function():
	die()
	pass

func _finish_function():
	pass

func die():
	actor.set_linear_velocity((1/(float(DifficultyScaler.difficulty_level)+10))*actor.velocity)

func float_away_corps():
	dead = true

func release_units():
	actor.z_index = -3
	actor.get_main_scene.killed_enemies += 1
	for hp_point in (actor.max_hp+1):
		actor.get_main_scene._spawn_unit_v2(actor.kind_of_enemy,actor.position)
		actor.get_main_scene.units_in_battle[actor.kind_of_enemy] +=1
	actor.get_main_scene.check_max_number_of_unit()
	actor.get_main_scene.difficulty_checker()

func explode():
	var expolosion = actor.explosion_package.instance()
	actor.get_main_scene.get_node("Explosions").add_child(expolosion)
	expolosion.position = actor.position
	expolosion.scale = Vector2(2,2)
	match actor.kind_of_enemy:
		0:
			expolosion.part_1.modulate = Color(0,0,1,1)
		1:
			expolosion.part_1.modulate = Color(1,1,0,1)
		2:
			expolosion.part_1.modulate = Color(0,1,0,1)
