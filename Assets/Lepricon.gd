extends Spatial

var moving = 0

func set_moving_left():
	if (moving != 1):
		moving = 1
		rotation_deg.y = 0
		$AnimationPlayer.play("default")

func set_moving_right():
	if (moving != 2):
		moving = 2
		rotation_deg.y = 180
		$AnimationPlayer.play("default")

func set_stop():
	moving = 0
	rotation_deg.y = 90
	$AnimationPlayer.stop(false)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass