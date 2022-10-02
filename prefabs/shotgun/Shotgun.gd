extends Weapon


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func shoot(shot_angle, collision_layer = 1):
	
	.shoot(shot_angle)
	
	for i in 5:
		var point_angle : float = (shot_angle + $WeaponPivot.rotation) + deg2rad(rand_range(-5,5))
		
		var shot_direction := Vector2(cos(point_angle), sin (point_angle))
		
		spawn_bullet(bullet_properties, $WeaponPivot/Sprite/BulletPivot.global_position, shot_direction, collision_layer)
	
	
	
