extends KinematicBody

signal gameover
signal game_restart

# losely based on godot 3d platform demo 
var start_position = Vector3()

var linear_velocity = Vector3()
var default_gravity = Vector3(0, -0.75, 0)
var up = Vector3(0.0, 1.0, 0.0)

var floor_accelerate = 18.0
var floor_drag = 10.0

var jump_speed = 10.0
var jump_accelerate = 5.0
var jump_cooldown = 0.0

var wind_drag = 1.0
var max_speed = 7

var jumping = false
var is_double_jump = false
var game_over = false

var above_fans = Array()

export var score = 0

func is_player():
	return true
	
func update_score():
	get_node("Control/Score").text = "Score: " + String(score)

func add_to_score(value):
	score += value
	update_score()

func add_fan(name):
	if !above_fans.has(name):
		above_fans.push_back(name)

func remove_fan(name):
	if above_fans.has(name):
		above_fans.erase(name)

func _fixed_process(delta):
	if (game_over):
		return
		
	var gravity = default_gravity
	if (above_fans.size() > 0):
		gravity = Vector3(0.0, 1.0, 0.0)
	
	if (jump_cooldown > 0):
		jump_cooldown -= delta
	
	var new_velocity = Vector3()
	
	# we should change this from using up to the normal of the floor/colision shape we're on
	var floor_normal = up
#	if (is_on_floor() and get_slide_count() > 0):
	if (get_slide_count() > 0):
		floor_normal = get_slide_collision(0).normal
		
	var vertical_velocity = floor_normal.dot(linear_velocity)
	var horizontal_velocity = linear_velocity - (floor_normal * vertical_velocity)
	var horizontal_direction = horizontal_velocity.normalized()
	var horizontal_speed = horizontal_velocity.length()
	
	var intended_direction = Vector3()
	
	if (Input.is_action_pressed("move_left")):
		intended_direction = floor_normal.cross(Vector3(-1.0, 0.0, 0.0))
	elif (Input.is_action_pressed("move_right")):
		intended_direction = floor_normal.cross(Vector3(1.0, 0.0, 0.0))
	
	if (is_on_floor()):
		# we are colliding with a floor, move along that floor
		
		# use our intended direction as the start for our new velocity
		new_velocity = intended_direction * floor_accelerate * delta;
		
		# add our deceleration to simulate drag on our current movement
		horizontal_speed -= floor_drag * delta
		if (horizontal_speed > 0):
			new_velocity += horizontal_direction * horizontal_speed
		
		# check max speed
		var speed = new_velocity.length();
		if (speed > max_speed):
			new_velocity *= max_speed / speed
		
		# implement start of jump by adding a velocity along our floor_normal
		if (Input.is_action_pressed("jump") and not jumping and jump_cooldown <= 0):
			new_velocity += up * jump_speed
			jumping = true
			# add play sound
		else:
			new_velocity += gravity
		
	else:
		# we are in the air...
		
		# allow a little control here..
		new_velocity = intended_direction * floor_accelerate * delta;

		# start with adjusting our current velocity with a bit of drag...
		var speed = linear_velocity.length()
		speed -= wind_drag * delta
		if (speed > 0):
			new_velocity += linear_velocity.normalized() * speed;
		
		if (Input.is_action_just_pressed("jump") and jumping and not is_double_jump):
			new_velocity += up * jump_speed
			is_double_jump = true
		else:
			# Apply our gravity
			new_velocity += gravity
	
	if (jumping and new_velocity.y < 0):
		jumping = false
		is_double_jump = false
		jump_cooldown = 0.5
	
	linear_velocity = move_and_slide(new_velocity,floor_normal)
	
	if (linear_velocity.z < 0):
		$Lepricon.set_moving_right()
	elif (linear_velocity.z > 0):
		$Lepricon.set_moving_left()
	else:
		$Lepricon.set_stop()
	
	if (translation.y < -10.0):
		get_node("Control/Button").visible = true
		get_node("Control/Game over").visible = true
		game_over = true
		emit_signal("gameover")

func reset_game():
	translation = start_position
	linear_velocity = Vector3()
	score = 0
	update_score()
	get_node("Control/Button").visible = false
	get_node("Control/Game over").visible = false
	game_over = false
	emit_signal("game_restart")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	start_position = translation
	update_score()

func _on_Button_pressed():
	reset_game()