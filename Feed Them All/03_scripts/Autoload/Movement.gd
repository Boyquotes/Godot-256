extends Node2D

const DEAFAULT_MASS: = 5.0
const DEAULT_MAX_SPEED: = 500.0

static func go(
		velocity:Vector2,
		units_position:Vector2,
		target_position:Vector2,
		max_speed: = DEAULT_MAX_SPEED,
		mass: = DEAFAULT_MASS 
):
	var desired_velocity: = (target_position-units_position).normalized()*max_speed
	var focusing_on_target: = (desired_velocity-velocity)/mass
	return velocity+focusing_on_target


