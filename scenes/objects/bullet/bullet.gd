class_name Projectile

extends Area2D

@onready var projectile_handler: ProjectileHandler = $ProjectileHandler
var origin_group: String = "" # The group (friendly, enemy, etc.) that fired the bullet
var origin_velocity: Vector2 = Vector2.ZERO # The velocity of the originating emitter


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	projectile_handler.update_position(self, delta, origin_velocity)


func _on_area_entered(area):
	var target_group


func _on_visible_on_screen_notifier_2d_screen_exited():
	$DeathTimer.start()


func _on_death_timer_timeout():
	queue_free()
