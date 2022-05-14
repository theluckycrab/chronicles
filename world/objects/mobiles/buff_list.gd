extends Spatial

var list = []
onready var host = get_parent()
	
func process():
	for i in list:
		i.execute(host)

func add_passives(source):
	for i in source.passive:
		var e = Data.get_reference_instance(i, false)
		e.enter(host)
		list.append(e)
		e.source = source
		print("adding ", source)
	pass
	
func remove_passives(source):
	for i in list:
		if i.source == source:
			print("remove ", source)
			i.exit(host)
			list.erase(i)
	pass
