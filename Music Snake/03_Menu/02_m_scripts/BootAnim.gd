extends Node2D

signal boot_ended

func _ready():
	pass # Replace with function body.

func start_boot_anim():
	$AnimationPlayer.play("BootAnim")


func _on_AnimationPlayer_animation_finished(anim_name):
	GlobalSignals.emit_signal("boot_ended")
	self.visible = false

