extends Spatial

func _on_VisibilityNotifier_screen_entered():
	print("Start particles for " + get_name())
	$Particles.emitting = true

func _on_VisibilityNotifier_screen_exited():
	print("Stop particles for " + get_name())
	$Particles.emitting = false


func _on_Area_body_entered( body ):
	# print(body.get_name() + " entered " + get_name())
	
	# should only be the player character..	
	if body.has_method("add_fan"):
		body.add_fan(get_name())

func _on_Area_body_exited( body ):
	# print(body.get_name() + " exited " + get_name()) 

	# should only be the player character..	
	if body.has_method("remove_fan"):
		body.remove_fan(get_name())
