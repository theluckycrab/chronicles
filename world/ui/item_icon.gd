extends Control

var item = "debug_item"


func _ready() -> void:
	item = Data.get_reference(item)
	build(item)
	$Label.text = item.item_name


func build(n_item:Item) -> void:
	item = n_item
	$Viewport/Preview.mesh = n_item.get_mesh()
	var a1 = $Viewport/Preview.mesh.get_aabb()
	$Viewport/Camera.global_transform.origin = Vector3(0, a1.position.y + (a1.size.y/2), 1)
	var s = a1.size
	if s.x > s.y:
		s = s.x
	elif s.y >= s.x:
		s = s.y
	if s > 0:
		$Viewport/Camera.size = s * 1.1
	
	
func refresh(i) -> void:
	item = i
	_ready()
	pass
