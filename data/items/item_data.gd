class_name Item
extends Resource

export var item_name = "Debug Item"
export var slot = "Offhand"
export var mesh = "naked" setget ,get_mesh
export var description = "no description set" 
export var is_modified = false
export var count = 1
export var durability = 3
export var tags = []
				

export(Dictionary) var attacks = {
		falling = "Combat_Idle",
		dash = "Sit_Floor",
		strong = "Test_LAttack1"
}

export(Dictionary) var abilities = {
		passive = [],
		active = "high_jump"
}

var index setget , get_index
var net_stats = NetStats.new()


func _init() -> void:
	index = item_name.to_lower().replace(" ", "_")
	net_stats.original_instance_id = get_instance_id()
	net_stats.index = get_index()

#command
func activate(host: Object) -> void:
	Data.get_reference(get_active()).execute(self, host)
	



#set
func add_tag(tag):
	add_tags(tag)

func add_tags(tag) -> void:
	if has_tag(tag):
		return
	if ! tag is Array:
		tags.append(tag)
	else:
		for i in tag:
			tags.append(i)
			
			
func remove_tag(tag: String) -> void:
	tags.remove(tag)
	
	
func set_name(n: String) -> void:
	item_name = n
	
func set_slot(s: String) -> void:
	slot = s
	
	
func set_description(d: String) -> void:
	description = d
	
	
func set_ability(a_name: String) -> void:
	abilities.active = Data.abilities[a_name].duplicate()

#get
func get_tags() -> Array:
	return tags


func get_index() -> String:
	return item_name.to_lower().replace(" ", "_")
	
	
func get_active() -> String:
	return abilities.active
	
	
func get_name() -> String:
	return item_name
	
	
func get_mesh() -> ArrayMesh:
	if mesh is String:
		mesh = Data.get_mesh(mesh)
	return mesh
	
	
func get_slot() -> String:
	return slot
	
	
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
	return tags.has(tag)
