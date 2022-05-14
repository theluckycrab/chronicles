extends Spatial

var net_objects = {}


func _ready() -> void:
	var _discard = Events.connect("spawn", self, "on_spawn")
	print(Network.nid())
	var args = {
		type = "mobile",
		netID = Network.nid(),
		netOwner = Network.nid(),
		index = "player",
		position = $PlayerSpawn.global_transform.origin
	}
	Network.relay_signal("spawn", args)
	Network.rpc_id(1, "request_history")
	
func on_spawn(args) -> void:
	call_deferred("spawn", args)


func spawn(args) -> void:
	var object
	match args.type:
		"item":
			object = load("res://world/objects/generic/item_cube.tscn").instance()
			object.item = args.index
		"mobile":
			object = load("res://world/objects/mobiles/"+args.index+"/"+args.index+".tscn").instance()
	if "net_stats" in object:
		object.netID = args.netID
		object.net_stats.netOwner = args.netOwner
	add_child(object)
	object.global_transform.origin = args.position
	net_objects[object.netID] = object


