extends Spatial

func _ready():
	Client.join()
	yield(get_tree(), "connected_to_server")
	get_history()
	
func get_history():
	Server.get_history("test_room")

func spawn(_args):
	pass

func despawn(_args):
	pass
