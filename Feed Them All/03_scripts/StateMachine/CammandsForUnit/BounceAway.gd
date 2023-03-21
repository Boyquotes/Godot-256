extends "res://03_scripts/StateMachine/PlatformCommand.gd"

func _unhandled_input(event):
	pass

func _physics_process(delta):
	pass


func _start_function():
	bounce_away()
	pass

func _finish_function():
	pass


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

func calculate_direction_for_bounce_away(my_pos,his_pos):
	var direction = Vector2.ZERO
	direction = (my_pos-his_pos).normalized()
	return direction

func bounce_away():
	actor.bounce_away(calculate_direction_for_bounce_away(actor.global_position,query_results_for_convexpoly_area(actor)[-1].global_position).normalized())
