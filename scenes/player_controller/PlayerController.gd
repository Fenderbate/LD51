extends Node2D


export(NodePath)var controlled_character_path : NodePath


var controlled_character : Character

var weapon : Weapon


var input_dir : Vector2 = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	
	SignalManager.connect("request_player_reference",self,"on_player_reference_requested")
	
	controlled_character = get_node(controlled_character_path)
	
	weapon = controlled_character.get_node("WeaponHolder/WeaponPivot").get_children()[0]
	
	controlled_character.collision_layer += 2
	
	controlled_character.add_to_group("Player")


func _input(event):
	
	if event.is_action_pressed("left_click") and event.is_pressed():
		if weapon.weapon_properties.ammo > 0:
			weapon.shoot(controlled_character.weapon_holder.rotation, 4)
		else:
			print("out of ammo")
		

	

func _process(delta):
	
	input_dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	input_dir.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	
	var rel_pos : Vector2 = controlled_character.global_position - get_global_mouse_position()
	var mouse_angle : float = atan2(rel_pos.y,rel_pos.x)
	
	
	controlled_character.velocity = input_dir * controlled_character.speed
	controlled_character.weapon_direction = mouse_angle
	
	$CanvasLayer/AmmoDrawer.update()
	

func on_player_reference_requested(requester_instance_id):
	
	SignalManager.emit_signal("send_player_reference",requester_instance_id, controlled_character.get_path())
	
