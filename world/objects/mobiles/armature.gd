extends Spatial

onready var equipment: Dictionary
onready var host = get_parent()
onready var anim = $AnimationPlayer


func equip(args:Dictionary) -> void:
	var item = Data.get_reference_instance(args.index)
	var mount = get_node_or_null("Skeleton/"+item.get_slot())
	var slot = item.get_slot()
	if slot == "Mainhand":
		mount = get_node_or_null("Skeleton/"+slot+"/Weapon/MeshInstance")
	if mount:
		mount.set_mesh(item.get_mesh())
		if item.get_slot() == "Mainhand":
			print("sizeable")
			size_weapon()
	
	
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


func play(animation, motion: bool = false) -> void:
	if motion:
		#anim.stop()
		anim.play_with_root_motion(animation)
		print("playing motion for ", animation)
	else:
		anim.tree.active = false
		anim.play(animation)
	

func get_root_motion():
	return anim.get_root_motion()
	
	
func get_animation() -> String:
	if anim.is_playing():
		return anim.current_animation
	elif anim.tree.active:
		if !anim.tree.get("parameters/OneShot/active"):
			return ""
		return anim.tree.get_tree_root().get_node("Action").animation
	else:
		return ""
	
	
func guard(dir:String) -> void:
	$Guardbox.guard(dir)
	
	
func guard_reset() -> void:
	$Guardbox.reset()
	
	
func size_weapon() -> void:
	var mesh = $Skeleton/Mainhand/Weapon/MeshInstance
	var box = $Skeleton/Mainhand/Weapon/MeshInstance/Hitbox/CollisionShape
	var length = mesh.get_aabb().size
	var pos = mesh.get_aabb().position
	box.transform.origin = pos + length / 2
	box.get_shape().set_extents(length / 2)


func get_hit_origin() -> Vector3:
	return $HitOrigin.global_transform.origin
