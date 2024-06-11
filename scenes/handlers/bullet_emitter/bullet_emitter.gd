@tool
extends Marker2D

@onready var fire_rate_timer = $FireRateTimer
@export var fire_rate: float = 0.5
# If there is no bullet set for the emitter, display a warning
@export var base_bullet: PackedScene = null:
	set(p_bullet):
		if (p_bullet != base_bullet):
			base_bullet = p_bullet
			update_configuration_warnings()

var can_fire: bool = true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if base_bullet == null:
		warnings.append('Needs a bullet, add one in the Inspector.')
	return warnings


# Called when the node enters the scene tree for the first time.
func _ready():
	# When the timer times out, allow firing again
	fire_rate_timer.connect("timeout", func (): can_fire = true)
	fire_rate_timer.wait_time = fire_rate
	


func fire_bullet(root_transform : Transform2D, origin_velocity : Vector2) -> void:
	var current_scene = get_tree().current_scene
	
	# If we can't fire yet, don't do anything
	if !can_fire:
		return
	
	# Disable firing until the fire_rate_timer has timed out again
	can_fire = false
	fire_rate_timer.start()
	
	# Create a bullet. We need to tell the bullet where it is and what direction it's facing.
	var bullet = base_bullet.instantiate()
	bullet.transform = root_transform
	bullet.origin_velocity = origin_velocity
	current_scene.add_child(bullet)

