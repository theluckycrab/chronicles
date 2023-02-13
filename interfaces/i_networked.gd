extends BaseInterface
class_name INetworked

func _init(h).(h, "networked"):
	pass

func npc(function: String, args: Dictionary):
	args["function"] = function
	args["uuid"] = int(name)
	Server.npc(args)

func net_sync():
	pass
	
func is_dummy() -> bool:
	return false
