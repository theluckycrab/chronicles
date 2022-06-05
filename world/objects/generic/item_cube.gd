extends Spatial

export(String) var item = "debug_item"
export(bool) var one_shot = true

var net_stats = NetStats.new("item_cube")


func _ready() -> void:
	net_stats.register()
	item = Data.get_item(item)
	$Viewport/Preview.mesh = item.get_mesh()
	var a1 = $Viewport/Preview.mesh.get_aabb()
	$Viewport/Camera.global_transform.origin = Vector3(0, a1.position.y + (a1.size.y/2), 1)
	var s = a1.size
	if s.x > s.y:
		s = s.x
	elif s.y >= s.x:
		s = s.y
	if s > 0:
		$Viewport/Camera.size = s * 1.1
	
func activate(host):
	host.add_item(item)
	if one_shot:
		queue_free()
