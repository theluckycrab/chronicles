extends Spatial

var list: Array = []

onready var host = get_parent()
	
	
func process() -> void:
	for i in list:
		i.execute(host)


func add_passives(source) -> void:
	for i in source.passive:
		var e = Data.get_reference_instance(i)
		e.enter(host)
		list.append(e)
		e.source = source
		print("adding ", source)
	
	
func remove_passives(source) -> void:
	for i in list:
		if i.source == source:
			print("remove ", source)
			i.exit(host)
			list.erase(i)
