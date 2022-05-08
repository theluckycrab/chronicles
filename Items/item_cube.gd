extends Spatial

export(String) var item

func _ready():
	item = load(Data.items[item]).duplicate(true)
	$Viewport/Preview.mesh = load(item.visual.mesh_file_path).duplicate(true)
	var a1 = $Viewport/Preview.mesh.get_aabb()
	$Viewport/Camera.global_transform.origin = Vector3(0, a1.position.y + (a1.size.y/2), 1)
	var s = a1.size
	if s.x > s.y:
		s = s.x
	elif s.y >= s.x:
		s = s.y
	$Viewport/Camera.size = s * 1.1
