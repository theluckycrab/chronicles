extends Spatial

var spawn_args = {
			parent = self,
			position=Vector3(0,0,0), 
			index="debug_item", 
			type="item", 
			modificiations={},
			netID = 0
			}
			
var net_objects = {}


func _ready() -> void:
	var _discard = Events.connect("spawn", self, "on_spawn")
	Network.call_deferred("relay_signal", "spawn", {
			type="mobile", 
			index="player", 
			position=$PlayerSpawn.global_transform.origin,
			modifiations={},
			netID=Network.nid_gen()
	})
	
	
func on_spawn(args) -> void:
	spawn(args)


func spawn(args) -> void:
	for i in spawn_args:
		if !args.has(i):
			args[i] = spawn_args[i]
	var object
	match args.type:
		"item":
			object = load("res://world/objects/generic/item_cube.tscn").instance()
			object.item = args.index
		"mobile":
			object = load("res://world/objects/mobiles/"+args.index+"/"+args.index+".tscn").instance()
	add_child(object)
	object.global_transform.origin = args.position
	#object.netID = args.netID
	#net_objects[object.netID] = object


