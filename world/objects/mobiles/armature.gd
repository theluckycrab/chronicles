extends Spatial

onready var defaults = {"Head":Data.get_reference_instance("wizard_hat")}
onready var equipment = defaults.duplicate(true)
onready var host = get_parent()

func equip(item):
	var mount = get_node_or_null("Skeleton/"+item.visual.slot)
	if item.visual.slot == "Offhand" or item.visual.slot == "Mainhand":
		mount = get_node_or_null("Skeleton/"+item.visual.slot+"/"+item.visual.slot)
	if mount:
		mount.set_mesh(load(item.visual.mesh_file_path).duplicate(true))
	equipment[item.visual.slot] = item
	pass
		
	
func unequip(_item):
	pass
	
func set_default(_slot, _item):
	pass
