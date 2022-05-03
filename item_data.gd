class_name Item
extends Resource

enum Slots{HEAD, CHEST, GLOVES, LEGS, BOOTS}

var stats = {
				slot = Slots.HEAD,
				mesh_file_path = "res://Blender/BaseHumanoid/pants.mesh",
				is_modified = false,
				item_name = "Balls",
				count = 1,
				ability = preload("res://high_jump.tres"),
				tags = []
}

func activate(host):
	stats.ability.execute(host)

func get_tags():
	return stats.tags
	
func has_tag(tag):
	return stats.tags.has(tag)
	
func add_tag(tag):
	if has_tag(tag):
		return
	if ! tag is Array:
		stats.tags.append(tag)
	else:
		for i in tag:
			stats.tags.append(i)
	
func remove_tag(tag):
	stats.tags.remove(tag)
