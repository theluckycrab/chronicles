class_name Item
extends Resource

export(Dictionary) var visual = {
				item_name = "name not set",
				slot = "slot not set",
				mesh_file_path = "res://data/assets/Blender/BaseHumanoid/pants.mesh",
				description = "no description set"
				
}

export(Dictionary) var overrides = {
				
}

export(Array, String) var passive = []

export(Dictionary) var active = {
				ability = "high_jump"
}

export(Dictionary) var internal = {
				index = "debug_item",
				is_modified = false,
				count = 1,
				tags = []
}

export(Dictionary) var combat = {
				durability = 10
}

var netID setget set_netID, get_netID

var net_stats = NetStats.new()

func _init():
	net_stats.original_instance_id = get_instance_id()
	net_stats.base_data_index = internal.index
	#Network.relay_signal("register_object", net_stats.net_sum())


func activate(host: Object) -> void:
	Data.get_reference(active.ability).execute(self, host)


func get_tags() -> Array:
	return internal.tags
	
	
func has_tag(tag) -> bool:
	return internal.tags.has(tag)
	
	
func add_tags(tag) -> void:
	if has_tag(tag):
		return
	if ! tag is Array:
		internal.tags.append(tag)
	else:
		for i in tag:
			internal.tags.append(i)
	
	
func remove_tag(tag: String) -> void:
	internal.tags.remove(tag)
	
	
func set_name(n: String) -> void:
	internal.item_name = n


func set_slot(s: String) -> void:
	visual.slot = s
	
	
func set_description(d: String) -> void:
	visual.description = d


func set_mesh_file_path(p: String) -> void:
	visual.mesh_file_path = p
	
	
func set_ability(a_name: String) -> void:
	active.ability = Data.abilities[a_name].duplicate()
	
func set_netID(nid):
	net_stats.netID = nid
	pass
	
func get_netID():
	return net_stats.netID
