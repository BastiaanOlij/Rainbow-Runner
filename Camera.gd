extends Camera

var target_offset = Vector3()
var current_velocity = Vector3()

var drag = 5

func reset_camera():
	current_velocity = Vector3()
	translation = get_node("../Player").translation + target_offset

func _process(delta):
	var player_position = get_node("../Player").translation
	var new_velocity = Vector3()
	
	# dampen our last velocity
	var speed = current_velocity.length()
	speed -= drag * delta
	if (speed > 0):
		new_velocity += current_velocity.normalized() * speed
	
	var target_position = player_position + target_offset
	var direction = target_position - translation
	
	new_velocity += direction * 0.95 * delta;
	current_velocity = new_velocity
	
	# add our new velocity
	translation += current_velocity
	
	# always look at the player..
	look_at(player_position, Vector3(0.0, 1.0, 0.0))
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	target_offset = translation - get_node("../Player").translation
