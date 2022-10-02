extends YSort


onready var mesh_instance : MeshInstance2D = $SpriteMesh
onready var multi_mesh_instance : MultiMeshInstance2D = $GrassInstance




# Called when the node enters the scene tree for the first time.
func _ready():
	
	Global.reset()
	
	var multimesh = multi_mesh_instance.multimesh
	multimesh.mesh = mesh_instance.mesh
	var area : Vector2 = Vector2(1280, 720) *3
	
	for index in multimesh.instance_count:
		var position : Vector2 = Vector2(randf() * area.x, randf() * area.y)
		var transform : Transform2D = Transform2D(0.0, position)
		multimesh.set_instance_transform_2d(index, transform)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
