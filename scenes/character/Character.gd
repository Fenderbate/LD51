class_name Character
extends KinematicBody2D



export(float)var speed : float = 100

export(int)var health : int = 3

var direction : Vector2 = Vector2()

var velocity : Vector2 = Vector2()

var weapon_direction : float

var weapon_holder : Node2D

var ai = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Character")
	
	weapon_holder = $WeaponHolder
	
	if has_node("EnemyController"):
		ai = true


func _physics_process(delta):
	
	if !has_node("EnemyController"):
	
		velocity = move_and_slide(velocity)
	
	weapon_holder.rotation = weapon_direction + deg2rad(180)
	

func hurt(damage):
	
	health -= damage
	
	if health <= 0:
		
		collision_layer = 0
		hide()
		
		if has_node("PlayerController"):
			SignalManager.emit_signal("game_over")
		
	

