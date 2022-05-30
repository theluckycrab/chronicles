extends Spatial

onready var defaults: Dictionary = {"Head":Data.get_reference_instance("bandana")}
onready var equipment: Dictionary
onready var host = get_parent()
onready var anim = $AnimationPlayer


func equip(args) -> void:
	var item = Data.get_reference_instance(args.index)
	var mount = get_node_or_null("Skeleton/"+item.visual.slot)
	if item.visual.slot == "Offhand" or item.visual.slot == "Mainhand":
		mount = get_node_or_null("Skeleton/"+item.visual.slot+"/"+item.visual.slot)
	if mount:
		mount.set_mesh(load(item.visual.mesh_file_path).duplicate(true))
	
	
func activate_item(args) -> void:
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


func play(animation, motion=false):
	$AnimationPlayer.play(animation)
	
	
func get_animation():
	return anim.current_animation
