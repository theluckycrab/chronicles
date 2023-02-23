extends Spatial

var mobile: PackedScene = preload("res://mobiles/mobile.tscn")

func _ready():
	get_history()
	
func get_history():
	Server.get_history("test_room")

func spawn(args):
	var m = mobile.instance()
	add_child(m)
	if args.unit == "player":
		if args.unit_uuid != Client.nid:
			args.unit = "dummy"
			print("dummy")
	var data = Data.get_mobile_data(args.unit)
	if args.unit_uuid == Client.nid:
		for i in Data.get_char_data():
			data[i] = Data.get_char_value(i)
	m.name = str(args.unit_uuid)
	m.build_from_dictionary(data)
	m.global_transform.origin = args.position

func despawn(args):
	get_node(str(args.unit)).queue_free()
