extends BaseInterface
class_name INetworked

func _init(h).(h, "networked"):
	pass

func npc(function: String, args: Dictionary) -> void:
	args["function"] = function
	args["uuid"] = int(name)
	Server.npc(args)
		
func is_dummy() -> bool:
	return int(name) != Client.nid
