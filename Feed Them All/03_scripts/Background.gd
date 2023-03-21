extends Node2D

signal bubbles_are_stopped

var enemy_package = load("res://02_scenes/Enemy.tscn")
var bubble_package = load("res://02_scenes/Bubble.tscn")

onready var enemy_spawner = $EnemySpawner
onready var get_main_scene = get_tree().get_root().get_node("Main")

func _on_EnemySpawner_timeout():
	_spawn_bubble()

func _spawn_enemy(pos,mode=false,phase=0):
	var enemy = enemy_package.instance()
	enemy.position = pos
	if mode:
		enemy.tutorial_mode = mode
		enemy.tutorial_phase = phase
	get_main_scene.get_node("Enemies").add_child(enemy)



func _spawn_bubble():
	var bubble = bubble_package.instance()
	$Bubbles.add_child(bubble)
	bubble.playing = true
	bubble.position = Vector2(rand_range(70,410),rand_range(665,690))
	yield(bubble,"release_kraken")
	_spawn_enemy(bubble.position) 

func stop_spawning_bubbles():
	for bubble in $Bubbles.get_children():
		bubble.stop_bubble()
	#emit_signal("bubbles_are_stopped")

##################################################
#################### TUTORIAL ####################
##################################################
func tutorial_spawn_bubble(phase, mode = true, spawn_pos = Vector2(400,675)):
	var bubble = bubble_package.instance()
	$Bubbles.add_child(bubble)
	bubble.playing = true
	bubble.position = spawn_pos
	yield(bubble,"release_kraken")
	_spawn_enemy(bubble.position,mode,phase) 
