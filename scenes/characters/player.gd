extends CharacterBody2D

# Acceleration in pixels/sec^2
@export var acceleration = 20.0
# Maximum velocity in pixels/sec
@export var max_velocity = 1000.0
# Maximum rotation speed in radians/sec
@export var max_rotation_speed = PI/8
# Toggled by HUD element to enable deacceleration
var counter_thrusters = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var impulse = Vector2.ZERO
	
	# We don't zero our velocity to add space drift physics
	# Determine our direction of motion
	if Input.is_action_pressed("move_up"):
		impulse.y -= 1
	if Input.is_action_pressed("move_down"):
		impulse.y += 1
	if Input.is_action_pressed("move_left"):
		impulse.x -= 1
	if Input.is_action_pressed("move_right"):
		impulse.x += 1
	
	# Only add movement to velocity if we are impulsed in a direction
	if impulse.length() > 0:
		# Normalize our impulse vector for direction and add magnitude with our acceleration
		impulse = impulse.normalized() * acceleration
		
		# Get our velocity by adding impulse to our current velocity and capping it at a certain value
		velocity = Vector2(velocity + impulse).limit_length(max_velocity)
	
	if impulse.length() == 0 && velocity != Vector2.ZERO && counter_thrusters:
		# Get the negative direction of our velocity and apply our acceleration to it
		impulse = Vector2(-velocity.normalized() * acceleration)
		
		# Update our velocity by adding impulse to our current velocity and capping it at our max velocity
		var temp_velocity = Vector2(velocity + impulse)
		# If we've decelerated past the ZERO vector, set it to the ZERO vector instead
		if temp_velocity.normalized() == -velocity.normalized():
			velocity = Vector2.ZERO
		else:
			velocity = temp_velocity
	
	# Move the character according to the physics processor
	var motion = velocity * delta
	move_and_collide(motion)
