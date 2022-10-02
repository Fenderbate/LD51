class_name Bullet
extends Area2D


var speed : float = 100
var damage : int = 1
var bouncy : bool = false
var bounces : int = 3
var piercing : bool = false


var direction : Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Bullet")


func _physics_process(delta):
	
	position += direction * speed * delta
	


func _on_Bullet_body_entered(body):
	
	if body.is_in_group("Character"):
		
		body.hurt(damage)
		
		if !piercing:
			print("Bullet hit character and cannot pierce, removing...")
			queue_free()
	
	else:
		if bouncy:
			print("calculate bounce!")
		else:
			queue_free()
	
