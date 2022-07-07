class_name Item
extends Resource

export(String) var item_name = "Ballsack" setget set_name, get_name
export(String) var slot = "Offhand"
export(String) var mesh = "naked" setget ,get_mesh
export(String) var description = "no description set" 
export(bool) var is_modified = false
export(int) var count = 1
export(int) var durability = 3
export(PoolStringArray) var tags = []
export var active = "Evade" setget ,get_active
export(PoolStringArray) var passives = []

var index setget , get_index
var net_stats = NetStats.new()


func _init() -> void:
	net_stats.original_instance_id = get_instance_id()
	net_stats.index = get_index()

#command
func activate(host: Object) -> void:
	Data.get_reference(get_active()).execute(self, host)
	
#set
func add_tag(tag:String) -> void:
	add_tags(tag)


func add_tags(tag) -> void: #single or many
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
	index = Data.snake_case(item_name)
	
	
func set_slot(s: String) -> void:
	slot = s
	
	
func set_description(d: String) -> void:
	description = d
	
	
func set_active(a_name: String) -> void:
	active = a_name
	active = Data.get_ability(a_name)

#get
func get_tags() -> Array:
	return tags


func get_index() -> String:
	return Data.snake_case(item_name)
	
	
func get_active() -> String:
	if active is String:
		var node = Node.new()
		Data.add_child(node)
		active = Data.snake_case(active)
		node.script = load("res://data/abilities/"+active+".gd")
		active = node
	return active
	
	
func renew_active() -> void:
	if ! active is String:
		var a = active.index
		active = a
	
	
func get_name() -> String:
	return item_name
	
	
func get_mesh() -> ArrayMesh:
	if mesh is String:
		mesh = Data.get_mesh(mesh)
	return mesh
	
	
func get_slot() -> String:
	return slot
	
	
func get_list_of_passives() -> Array:
	return passives

#query
func has_tag(tag:String) -> bool:
	return tag in tags
