extends Control

export(Resource) var item

func _ready():
	$Viewport/Preview.mesh = load(item.stats.mesh_file_path).duplicate(true)
	var a1 = $Viewport/Preview.mesh.get_aabb()
	$Viewport/Camera.global_transform.origin = Vector3(0, a1.position.y + (a1.size.y/2), 1)
	var s = a1.size
	if s.x > s.y:
		s = s.x
	elif s.y >= s.x:
		s = s.y
	$Viewport/Camera.size = s * 1.1
	
