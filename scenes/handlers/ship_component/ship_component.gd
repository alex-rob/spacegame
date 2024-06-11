extends Node2D

# Acceleration in pixels/sec^2
@export var acceleration = 20.0
# Maximum velocity in pixels/sec
@export var max_velocity = 1000.0
# Rotation speed in radians/sec
@export var rotation_speed = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# This will rotate the ship to face a specific target. Typically, this will be the mouse.
func rotateToTarget(target, delta):
	var direction = Vector2.ZERO
	var parent = get_parent()
	
	# Figure out where the player needs to be looking. Vector from player location to target location
	if type_string(typeof(target)) == "Vector2":
		direction = (target - parent.global_position)
	else:
		direction = (target.global_position - parent.global_position)
	
	# From our current rotation, figure out how much angle we have left to rotate
	var angleTo = parent.transform.x.angle_to(direction)
	
	# Get the sign of angleTo to define rotation direction (cw/ccw), then multiply that by either
	# our delta * rotation_speed or our angleTo, whichever is lower. This avoids overshoot.
	parent.rotate(sign(angleTo) * min(delta * rotation_speed, abs(angleTo)))
