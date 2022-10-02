extends Control

export(NodePath)var controller_path : NodePath

var controller

func _ready():
	
	controller = get_node(controller_path)
	

func _draw():
	
	var draw_start_pos := Vector2(16, get_viewport_rect().size.y - 128)
	
	for i in controller.weapon.weapon_properties.ammo:
		draw_texture(controller.weapon.ammo, Vector2(draw_start_pos.x, draw_start_pos.y - (controller.weapon.ammo.get_size().y + 16) * i))
