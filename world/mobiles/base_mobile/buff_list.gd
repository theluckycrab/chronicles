extends Spatial

var list: Array = []

onready var host = get_parent()
	
	
func process() -> void:
	for i in list:
		i.execute(host)
		
		
func add_effect(source, index:String) -> void:#source can be anything
	var e = load("res://data/effects/"+index+".gd").new()
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
	
	
func remove_passives(source) -> void:#source can be anything
	for i in list:
		if i.source == source:
			i.exit(host)
			list.erase(i)
			
			
func clear_effects():
	for i in list:
		i.exit(host)
	list.clear()
