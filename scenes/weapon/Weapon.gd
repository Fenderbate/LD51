class_name Weapon
extends Node2D

onready var bullet := preload("res://scenes/bullet/Bullet.tscn")
onready var ammo : Texture = preload("res://sprites/bullet_dispaly.png")

export(Dictionary)var bullet_properties : Dictionary = {
	
	"speed" : 100,
	"damage" : 1,
	"bouncy" : false,
	"bounces" : 3

}
var _bullet_properties : Dictionary





export(Dictionary)var weapon_properties : Dictionary = {
	
	"sway" : 0,
	"max_sway_angle" : 0,
	"bullet_count" : 0,
	"auto_fire" : false,
	"auto_fire_interval" : 0,
	"infinite_ammo" : false,
	"ammo" : 0
}
var _weapon_properties : Dictionary



# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Weapon")
	
	_weapon_properties = weapon_properties.duplicate()
	_bullet_properties = bullet_properties.duplicate()
	
	_weapon_properties = _weapon_properties.duplicate()
	_bullet_properties = _bullet_properties.duplicate()


func _physics_process(delta):
	
	$WeaponPivot.rotation_degrees -= $WeaponPivot.rotation_degrees / 5
	

func shoot(shot_angle, collision_layer = 1):
	
	$WeaponPivot.rotation_degrees += weapon_properties.sway * rand_range(-1,1)
	
	if (abs($WeaponPivot.rotation_degrees) > weapon_properties.max_sway_angle):
		$WeaponPivot.rotation_degrees = weapon_properties.max_sway_angle * ($WeaponPivot.rotation_degrees / abs($WeaponPivot.rotation_degrees))
		pass
	
	weapon_properties.ammo -= 1
	
	pass

func spawn_bullet(bullet_properties, bullet_position, bullet_direction, bullet_collision_mask):
	
	var b := bullet.instance()
	
	for property in bullet_properties:
		b.set(property, bullet_properties[property])
	
	b.global_position = bullet_position
	b.direction = bullet_direction
	b.collision_mask = bullet_collision_mask
	
	get_tree().root.get_node("Game").add_child(b)
	

