extends Spatial

export(String) var item = "debug_item"
onready var item_name = item
var net_stats = NetStats.new("item_cube")


func _ready() -> void:
	net_stats.register()
	item = Data.get_reference_instance(item)
	$Viewport/Preview.mesh = load(item.visual.mesh_file_path).duplicate(true)
	var a1 = $Viewport/Preview.mesh.get_aabb()
	$Viewport/Camera.global_transform.origin = Vector3(0, a1.position.y + (a1.size.y/2), 1)
	var s = a1.size
	if s.x > s.y:
		s = s.x
	elif s.y >= s.x:
		s = s.y
	$Viewport/Camera.size = s * 1.1
	print("Item Cube loaded")

func activate(target):
	Network.relay_signal("item_added", {netID = target.netID,
			item = self.item_name,
			count = 1,
			is_modified = false})
	pass
