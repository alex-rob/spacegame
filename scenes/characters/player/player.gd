extends CharacterBody2D

signal shoot(location : Transform2D, origin_velocity : Vector2)

# Toggled by HUD element to enable deacceleration
var counter_thrusters = true
@onready var ship = $ShipComponent
@onready var bullet_emitter = $BulletEmitter


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
		impulse = impulse.normalized() * ship.acceleration
		
		# Get our velocity by adding impulse to our current velocity and capping it at a certain value
		velocity = Vector2(velocity + impulse).limit_length(ship.max_velocity)
	
	if impulse.length() == 0 && velocity != Vector2.ZERO && counter_thrusters:
		# Get the negative direction of our velocity and apply our acceleration to it
		impulse = Vector2(-velocity.normalized() * ship.acceleration)
		
		# Update our velocity by adding impulse to our current velocity and capping it at our max velocity
		var temp_velocity = Vector2(velocity + impulse)
		# If we've decelerated past the ZERO vector, set it to the ZERO vector instead
		if temp_velocity.normalized() == -velocity.normalized():
			velocity = Vector2.ZERO
		else:
			velocity = temp_velocity
	
	if Input.is_action_pressed("shoot"):
		# Fire a bullet, giving it the direction we are facing.
		# Get the direction by constructing a vector (1,0) and rotating it with our own rotation.
		shoot.emit(bullet_emitter.global_transform, velocity)
	
	# Get the mouse position in the viewport
	var mouse_pos = get_viewport().get_mouse_position()
	ship.rotateToTarget(mouse_pos, delta)
	
	# Move the character according to the physics processor
	var motion = velocity * delta
	move_and_collide(motion)

