extends Area
class_name Interactable

var item = ""

func interact(host) -> void:
	host.add_item(Data.get_item(item))
	Simulation.despawn(self)
	pass

func _ready():
	add_to_group("interactable")

func highlight(color):
	for i in get_children():
		if i is MeshInstance:
			if color == "reset":
				i.material_override = null
				return
			else:
				var m
				if is_instance_valid(i.material_override):
					m = i.material_override
				m = SpatialMaterial.new()
				m.albedo_color = color
				i.material_override = m
				i.material_override.flags_no_depth_test = true

func build_from_dictionary(dict={}):
	if dict.has("item"):
		item = dict.item

func as_dict():
	return {"category":"interactable", "item":item}
