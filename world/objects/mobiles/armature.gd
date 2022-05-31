extends Spatial

onready var defaults: Dictionary = {"Head":Data.get_reference_instance("bandana")}
onready var equipment: Dictionary
onready var host = get_parent()
onready var anim = $AnimationPlayer


func equip(args:Dictionary) -> void:
	var item = Data.get_reference_instance(args.index)
	var mount = get_node_or_null("Skeleton/"+item.get_slot())
	var slot = item.get_slot()
	if slot == "Offhand" or slot == "Mainhand":
		mount = get_node_or_null("Skeleton/"+slot+"/"+slot)
	if mount:
		mount.set_mesh(load(item.get_mesh_file()).duplicate(true))
	
	
func activate_item(args:Dictionary) -> void:
	match args.source:
		"equipment":
			if !equipment.has(args.index):
				return
			equipment[args.index].activate(host)


func face(dir:Vector3) -> void:
	if dir == Vector3.ZERO:
		return
		
	var angle = atan2(dir.x, dir.z)
	rotation.y = lerp_angle(rotation.y, angle, 0.2)


func play(animation, _motion: bool = false) -> void:
	$AnimationPlayer.play(animation)
	
	
func get_animation() -> String:
	return anim.current_animation
	
	
func guard(dir:String) -> void:
	$Guardbox.guard(dir)
	
	
func guard_reset() -> void:
	$Guardbox.reset()
