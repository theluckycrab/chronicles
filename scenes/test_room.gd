extends Spatial

var mobile: PackedScene = preload("res://mobiles/mobile.tscn")

func _ready():
	if is_instance_valid(get_tree().network_peer):
		get_history()
		Chat.show()
	else:
		spawn({"unit":"dummy", "position":Vector3(0, 5, 0), "unit_uuid":1000})
		spawn({"unit":"dummy", "position":Vector3(-5, 5, 0), "unit_uuid":2000})
		spawn({"unit":"dummy", "position":Vector3(-10, 5, 0), "unit_uuid":3000})
		spawn({"unit":"player", "position":Vector3(0, 15, 0), "unit_uuid":1})
	
func get_history():
	Server.get_history("test_room")

func spawn(args):
	var o = null
	match args.object.category:
		"projectile":
			o = load("res://generics/base_projectile.tscn").instance()
		"mobile":
			o = load("res://mobiles/mobile.tscn").instance()
		"item_pickup":
			o = load("res://objects/interactable/item_pickup.tscn").instance()
	add_child(o)
	o.name = str(args.unit_uuid)
	o.build_from_dictionary(args.object)
	o.global_transform.origin = args.position
#	if args.unit == "player":
#		if args.unit_uuid != Client.nid:
#			args.unit = "player_dummy"
#	var data = Data.get_mobile_data(args.unit)
#	if args.unit_uuid == Client.nid:
#		for i in Data.get_char_data():
#			data[i] = Data.get_char_value(i)
	#m.name = str(args.unit_uuid)
	#m.build_from_dictionary(data)
	#m.global_transform.origin = args.position

func despawn(args):
	var u = get_node_or_null(args.unit)
	if is_instance_valid(u):
		get_node(str(args.unit)).queue_free()

func parse_npc(args):
	if !args.has("uuid"):
		print("Bad Packet : ", args)
		return
	if str(args.uuid) == name:
		call(args.function, args)
	else:
		var u = get_node_or_null(str(args.uuid))
		if is_instance_valid(u):
			u.call(args.function, args)
