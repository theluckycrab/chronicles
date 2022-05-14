extends Spatial

onready var defaults = {"Head":Data.get_reference_instance("wizard_hat")}
onready var equipment = defaults.duplicate(true)
onready var host = get_parent()

func _ready():
	for i in defaults:
		equip(defaults[i])

func equip(item):
	var mount = get_node_or_null("Skeleton/"+item.visual.slot)
	if item.visual.slot == "Offhand" or item.visual.slot == "Mainhand":
		mount = get_node_or_null("Skeleton/"+item.visual.slot+"/"+item.visual.slot)
	if mount:
		mount.set_mesh(load(item.visual.mesh_file_path).duplicate(true))
	for i in item.passive:
		Events.emit_signal("effect_added", {effect=i, source=item})
	pass
	
func destroy(slot):
	var mount = get_node_or_null("Skeleton/"+slot)
	if mount and defaults.has(slot):
		equip(defaults[slot])
	
func unequip(_item):
	pass
	
func set_default(_slot, _item):
	pass
