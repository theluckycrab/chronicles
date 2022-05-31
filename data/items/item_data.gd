class_name Item
extends Resource

export(Dictionary) var stats = {
				item_name = "name not set",
				slot = "slot not set",
				mesh_file_path = "res://data/assets/Blender/BaseHumanoid/pants.mesh",
				description = "no description set",
				index = "debug_item",
				is_modified = false,
				count = 1,
				tags = []
				
}

export(Dictionary) var attacks = {
		falling = "Combat_Idle",
		dash = "Sit_Floor",
		strong = "Test_LAttack1"
}

export(Dictionary) var abilities = {
		passive = [],
		active = "high_jump"
}

var net_stats = NetStats.new()


func _init() -> void:
	net_stats.original_instance_id = get_instance_id()
	net_stats.index = get_index()

#command
func activate(host: Object) -> void:
	Data.get_reference(get_active()).execute(self, host)
	



#set
func add_tags(tag) -> void:
	if has_tag(tag):
		return
	if ! tag is Array:
		stats.tags.append(tag)
	else:
		for i in tag:
			stats.tags.append(i)
			
			
func remove_tag(tag: String) -> void:
	stats.tags.remove(tag)
	
	
func set_name(n: String) -> void:
	stats.item_name = n
	
func set_slot(s: String) -> void:
	stats.slot = s
	
	
func set_description(d: String) -> void:
	stats.description = d


func set_mesh_file_path(p: String) -> void:
	stats.mesh_file_path = p
	
	
func set_ability(a_name: String) -> void:
	abilities.active = Data.abilities[a_name].duplicate()

#get
func get_tags() -> Array:
	return stats.tags


func get_index() -> String:
	return stats.index
	
	
func get_active() -> String:
	return abilities.active
	
func get_name() -> String:
	return stats.item_name
	
func get_mesh_file() -> String:
	return stats.mesh_file_path
	
func get_slot() -> String:
	return stats.slot
	
func get_list_of_passives() -> Array:
	return abilities.passive
	
func get_strong_attack() -> String:
	return attacks.strong
	
func get_dash_attack() -> String:
	return attacks.dash
	
func get_falling_attack() -> String:
	return attacks.falling

#query
func has_tag(tag) -> bool:
	return stats.tags.has(tag)
