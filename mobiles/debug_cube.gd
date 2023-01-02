extends MeshInstance

func _ready():
	add_to_group("loot")
	var _d = $Hitbox.connect("hit", self, "on_got_hit")

func highlight(color):
	if is_instance_valid(material_override):
		material_override = null
		return
	var m = SpatialMaterial.new()
	m.albedo_color = color
	material_override = m
	material_override.flags_no_depth_test = true

func on_got_hit(damage):
	#print(name, " got hit for ", damage)
	pass
