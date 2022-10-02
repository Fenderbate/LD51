extends Node2D


export(NodePath)var controlled_character_path : NodePath
export(float)var min_distance_to_player : float = 300

onready var nav_agent : NavigationAgent2D

var player : Character

var controlled_character : Character

var weapon : Weapon

var shooting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	controlled_character = get_node(controlled_character_path)
	
	#weapon = controlled_character.get_node("WeaponHolder/WeaponPivot").get_children()[0]
	
	#$ShootSwitchTimer.wait_time = weapon.weapon_properties.auto_fire_interval
	
	add_gun()
	
	nav_agent = controlled_character.get_node("NavAgent")
	
	SignalManager.connect("send_player_reference",self,"on_player_reference_sent")
	
	SignalManager.connect("game_over",self,"on_game_over")
	
	SignalManager.emit_signal("request_player_reference",get_instance_id())
	
	nav_agent.connect("velocity_computed",self,"_on_NavAgent_velocity_computed")
	
	nav_agent.max_speed = controlled_character.speed
	
	controlled_character.collision_layer += 4
	


func _process(delta):
	
	if player == null:
		SignalManager.emit_signal("request_player_reference",get_instance_id())
		
		return
	
	if nav_agent.is_navigation_finished():
		return
	
	var target_global_position := nav_agent.get_next_location()
	
	var direction := controlled_character.global_position.direction_to(target_global_position)
	
	var desired_velocity := direction * nav_agent.max_speed
	var steering : Vector2 = (desired_velocity - controlled_character.velocity) * delta * 4.0
	controlled_character.velocity += steering
	nav_agent.set_velocity(controlled_character.velocity)
	
	
	var rel_pos : Vector2 = controlled_character.global_position - player.global_position
	var target_angle : float = atan2(rel_pos.y,rel_pos.x)
	
	controlled_character.weapon_direction = target_angle
	
	
	$Raycast.cast_to = - (global_position - player.global_position)
	
	if $Raycast.is_colliding() and $Raycast.get_collider().is_in_group("Player"):
		if !shooting:
			shoot_gun()
			$ShootSwitchTimer.start()
		shooting = true
		
	else:
		shooting = false
	
	

func add_gun():
	
	var gun = load("res://prefabs/pistol/Pistol.tscn").instance()
	controlled_character.get_node("WeaponHolder/WeaponPivot").add_child(gun)
	
	weapon = controlled_character.get_node("WeaponHolder/WeaponPivot").get_children()[0]
	
	$ShootSwitchTimer.wait_time = weapon.weapon_properties.auto_fire_interval
	

func shoot_gun():
	
	weapon.shoot(controlled_character.weapon_holder.rotation, 2)
	
	pass
	


func on_player_reference_sent(requester_instance_id, player_path):
	
	if requester_instance_id != get_instance_id():
		return
	
	player = get_node(player_path)
	
	nav_agent.set_target_location(player.global_position)
	

func on_game_over():
	
	$PathUpdateTimer.stop()
	$ShootSwitchTimer.stop()
	set_process(false)
	

func _on_PathUpdateTimer_timeout():
	
	if player == null:
		return
	
	nav_agent.set_target_location(player.global_position)
	


func _on_NavAgent_velocity_computed(safe_velocity):
	
	if controlled_character.global_position.distance_to(player.global_position) > min_distance_to_player:
		controlled_character.velocity = controlled_character.move_and_slide(controlled_character.velocity)


func _on_ShootSwitchTimer_timeout():
	if shooting:
		shoot_gun()
		$ShootSwitchTimer.start()
	
