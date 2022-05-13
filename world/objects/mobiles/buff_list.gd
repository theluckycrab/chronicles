extends Spatial

var list = {}
onready var host = get_parent()
	
func process():
	for i in list:
		i.execute(host)

func add_effect(_effect):
	pass
	
func remove_effect(_effect):
	pass
