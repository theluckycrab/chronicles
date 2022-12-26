extends Spatial

func get_history():
	Server.get_history("test_room")

func _ready():
	yield(get_tree().create_timer(2), "timeout")
	get_history()

func spawn(args):
	print("Spawning ", args)
	var p = load("res://" + args.unit + ".tscn").instance()
	add_child(p)
	p.global_transform.origin = args.position
	p.name = str(args.unit_uuid)
