extends Area

var taken = false

func reset_taken():
	taken = false
	get_node("CoinMesh").visible = true
	get_node("AnimationPlayer").play("Rotate")
	

func _on_Coin_body_entered( body ):
	if (not taken and body.is_player()):
		body.add_to_score(10)
		get_node("AnimationPlayer").play("Taken")
		get_node("Sfx").playing = true
		taken = true
