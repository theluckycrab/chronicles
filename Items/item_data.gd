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
				ability = "High Jump"
}

export(Dictionary) var internal = {
				is_modified = false,
				count = 1,
				tags = []
}

func activate(host):
	active.ability.execute(host)

func get_tags():
	return internal.tags
	
func has_tag(tag):
	return internal.tags.has(tag)
	
func add_tags(tag):
	if has_tag(tag):
		return
	if ! tag is Array:
		internal.tags.append(tag)
	else:
		for i in tag:
			internal.tags.append(i)
	
func remove_tag(tag):
	internal.tags.remove(tag)
	
func set_name(n):
	internal.item_name = n

func set_slot(s):
	visual.slot = s
	
func set_description(d):
	visual.description = d

func set_mesh_file_path(p):
	visual.mesh_file_path = p
