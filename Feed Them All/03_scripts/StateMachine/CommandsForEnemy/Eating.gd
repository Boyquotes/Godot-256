extends "res://03_scripts/StateMachine/PlatformCommand.gd"

var eated_unit
var eating_swim_speed = 10

func _unhandled_input(event):
	pass

func _physics_process(delta):
	pass

func _start_function():
	eated_unit = query_results(actor)
	reduce_speed_for_eating(eated_unit)
	pass

func _finish_function():
	pass


func reduce_speed_for_eating(eated_unit):
	#actor.set_linear_velocity((1/(float(DifficultyScaler.difficulty_level)+10))*actor.velocity)
	actor.set_linear_velocity(actor.velocity.normalized()*eating_swim_speed)
	actor.set_linear_damp(4)

#	if actor.hp <= 0:
#		actor.disable_enemy_sides()
#		if actor.velocity.length() >-350:
#			actor.set_linear_damp(5)
#		if actor.velocity.length() <=-350:
#			actor.set_linear_damp(20)
#		yield(get_tree().create_timer(1),"timeout")
#		$EnemySprite.set_animation("Dieing")
#		actor.get_main_scene.killed_enemies += 1
#		for hp_point in actor.max_hp+1:
#			actor.get_main_scene._spawn_unit_v2(actor.kind_of_enemy,actor.position)
#			actor.get_main_scene.units_in_battle[actor.kind_of_enemy] +=1
#		actor.emit_signal("check_number_of_units")
#		yield($EnemySprite,"animation_finished")
#		queue_free()

func query_results(somebody):

	var select_poly = ConvexPolygonShape2D.new() 
	var extends_from_somebody = somebody.enemy_head_shape.polygon
	select_poly.points = extends_from_somebody
	var enemy_scale = somebody.enemy_head_shape.get_parent().scale.x
	var space = somebody.get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_layer = somebody.collision_layer_from_unit
	query.set_shape(select_poly)
	query.transform = somebody.transform
	query.exclude = [somebody.enemy_head_shape.get_parent()]
	var query_results = []
	query_results = space.intersect_shape(query)
	var overlapping_objects
	for i in query_results:
		#print(i["collider"].name + "  " + i["collider"].get_parent().name + "  " + str(i["collider"].get_parent().touched_by_enemy))
		if i["collider"].get_parent().touched_by_enemy:
			if i["collider"].get_parent().name_of_touching_enemy and i["collider"].get_parent().name_of_touching_enemy==actor:
				overlapping_objects = i["collider"].get_parent()
			#print("eated is " + overlapping_objects.name)
	#print("-------")
	return overlapping_objects

func jaw_closed():
	actor.hp -= 1
	eated_unit.state_machine.change_state_to("DieingState")
	if actor.hp <= 0:
		disable_enemy_collision_areas()
		actor.state_machine.change_state_to("DieingState")

func disable_enemy_collision_areas():
	actor.get_node("EnemyHead").set_deferred("monitoring", false)
	actor.get_node("EnemySides").set_deferred("monitoring", false)
	actor.get_node("EnemyHead").set_deferred("monitorable", false)
	actor.get_node("EnemySides").set_deferred("monitorable", false)
	actor.set_deferred("collision_mask", 0)
	actor.set_deferred("collision_layer", 0)

func call_swim_state():
	if not actor.hp <= 0 and not actor.washed_beacuse_of_new_game_started:
		actor.state_machine.change_state_to("SwimmingState")
	elif actor.washed_beacuse_of_new_game_started:
		actor.set_linear_velocity(Vector2(0,-500))
		actor.set_linear_damp(0)
