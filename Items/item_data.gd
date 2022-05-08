class_name Item
extends Resource

export(Dictionary) var visual = {
				item_name = "name not set",
				slot = "slot not set",
				mesh_file_path = "res://Blender/BaseHumanoid/pants.mesh",
				description = "no description set"
				
}

export(Dictionary) var overrides = {
				
}

export(Dictionary) var passive = {
				
}

export(Dictionary) var active = {
				ability = preload("res://Abilities/high_jump.tres")
}

export(Dictionary) var internal = {
				is_modified = false,
				count = 1,
				tags = []
}

export(Dictionary) var stats = {
				item_name = "name not set",
				is_modified = false,
				count = 1,
				ability = preload("res://Abilities/high_jump.tres"),
				tags = [],
				mesh_file_path = "res://Blender/BaseHumanoid/pants.mesh",
				description = "no description set"
}

func activate(host):
	stats.ability.execute(host)

func get_tags():
	return stats.tags
	
func has_tag(tag):
	return stats.tags.has(tag)
	
func add_tags(tag):
	if has_tag(tag):
		return
	if ! tag is Array:
		stats.tags.append(tag)
	else:
		for i in tag:
			stats.tags.append(i)
	
func remove_tag(tag):
	stats.tags.remove(tag)
	
func set_name(n):
	stats.item_name = n

func set_slot(s):
	stats.slot = s
	
func set_description(d):
	stats.description = d

func set_mesh_file_path(p):
	stats.mesh_file_path = p
