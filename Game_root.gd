extends Spatial

func _ready():
	# Disabled this in our editor, easier to edit, so turn it on in game...
	get_node("WorldEnvironment").environment.dof_blur_far_enabled = true

func _on_Player_game_restart():
	get_node("Camera").reset_camera()
	
	for coin in get_node("Coins").get_children():
		coin.reset_taken()

	get_node("Explination").visible = true
	get_node("Timer").start()


func _on_Timer_timeout():
	get_node("Explination").visible = false
