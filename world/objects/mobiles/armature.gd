extends Spatial

onready var defaults: Dictionary = {"Head":Data.get_reference_instance("bandana")}
onready var equipment: Dictionary
onready var host = get_parent()


func equip(item:Item) -> void:
	var mount = get_node_or_null("Skeleton/"+item.visual.slot)
	if item.visual.slot == "Offhand" or item.visual.slot == "Mainhand":
		mount = get_node_or_null("Skeleton/"+item.visual.slot+"/"+item.visual.slot)
	if mount:
		mount.set_mesh(load(item.visual.mesh_file_path).duplicate(true))
	equipment[item.visual.slot] = item
	
	
