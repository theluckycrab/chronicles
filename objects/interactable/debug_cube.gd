extends MeshInstance

var damages = []

func interact(target) -> void:
	target.global_transform.origin = $Position3D.global_transform.origin

func _ready():
	#$Hitbox.connect("got_hit", self, "on_got_hit")
	add_to_group("loot")
	
func on_got_hit(damage_profile) -> void:
	if damages.has(damage_profile):
		return
	else:
		damages.append(damage_profile)
	if damage_profile.has("strong"):
		print("so strong!~~~")
	else:
		print("pathetic")
	damages.clear()

func highlight(color):
	if color == "reset":
		material_override = null
		return
	else:
		var m
		if is_instance_valid(material_override):
			m = material_override
		m = SpatialMaterial.new()
		m.albedo_color = color
		material_override = m
		material_override.flags_no_depth_test = true
