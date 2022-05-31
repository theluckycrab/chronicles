extends Spatial

var list: Array = []

onready var host = get_parent()
	
	
func process() -> void:
	for i in list:
		i.execute(host)
		
		
func add_effect(source, index:String) -> void:#source can be anything
	var e = Data.get_reference_instance(index)
	e.source = source
	e.enter(host)
	list.append(e)
	
	
func remove_effect(index:String) -> void:
	for i in list:
		if i.index == index:
			i.exit(host)
			list.erase(i)
	

func add_passives(source) -> void:#source can be anything
	for i in source.passive:
		var e = Data.get_reference_instance(i)
		e.enter(host)
		list.append(e)
		e.source = source
		if "net_stats" in source:
			print("NetID ", source.net_stats.netID, ": add effect : ", e.effect_name)
		else:
			print("add effect : ", e.effect_name)
	
	
func remove_passives(source) -> void:#source can be anything
	for i in list:
		if i.source == source:
			if "net_stats" in source:
				print("NetID ", source.net_stats.netID, ": remove effect : ", i.effect_name)
			else:
				print("remove effect : ", i.effect_name)
			i.exit(host)
			list.erase(i)
