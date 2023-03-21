extends "res://03_scripts/StateMachine/PlatformCommand.gd"

func _unhandled_input(event):
	pass

func _physics_process(delta):
	if not query_results_for_convexpoly_area(actor).empty():
		actor.global_position += calculate_direction_for_move_away(actor.global_position,query_results_for_convexpoly_area(actor)[-1].global_position).normalized()*2
	else:
		actor.state_machine.change_state_to("InBattleState")

func _start_function():
	pass

func _finish_function():
	pass

func calculate_direction_for_move_away(my_pos,his_pos):
	var direction = Vector2.ZERO
	direction = (my_pos-his_pos).normalized()*2
	return direction

func query_results_for_convexpoly_area(somebody):
	var select_poly = CircleShape2D.new() 
	var radius_from_somebody = somebody.body_collision_shape.shape.radius
	select_poly.radius = radius_from_somebody
	var space = somebody.get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_layer = 512
	query.set_shape(select_poly)
	query.transform = somebody.transform
	query.exclude = [somebody.body_collision_shape.get_parent()]
	var query_results = []
	query_results = space.intersect_shape(query)
	var overlapping_objects = []
	for i in query_results:
		overlapping_objects.append(i["collider"])
	return overlapping_objects
