# projectile_movement_handler
# Note 6/8: Going to program this to only handle dumb projectiles first to avoid over-complicating.
#   I want this to be able to handle dumb and smart projectiles, however. Missiles are one example.

class_name ProjectileHandler

extends Node2D

# Member variables
@export var speed: float = 1500
@export var damage: float = 10.0
var velocity = Vector2.RIGHT
#@export var acceleration: float = 0
#@export var can_accelerate: bool = false
#@export var can_track_target: bool = false

# Set our velocity when the bullet instantiates
func _ready():
	velocity = Vector2(velocity * speed).rotated(get_parent().rotation)

# Update the position based on the member variables
func update_position(projectile : Projectile, delta : float, origin_velocity : Vector2 = Vector2.ZERO) -> void:
	# If we have an origin_velocity, add it to the velocity
	if origin_velocity == Vector2.ZERO:
		projectile.position += velocity * delta
	else:
		projectile.position += (velocity + origin_velocity) * delta


func deal_damage(target : Node2D) -> void:
	pass
