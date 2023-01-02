extends Spatial

func get_history():
	Server.get_history("test_room")

func _ready():
	yield(get_tree().create_timer(2), "timeout")
	get_history()

func spawn(args):
	#print("Spawning ", args)
	var p = load("res://mobiles/" + args.unit + ".tscn").instance()
	if args.has("spawn_args"):
		for i in args.spawn_args:
			#print(i)
			if p.has_method("set_"+i):
				#print("setting ", i)
				p.call("set_"+i, args.spawn_args[i])
	add_child(p)
	p.global_transform.origin = args.position
	p.name = str(args.unit_uuid)
