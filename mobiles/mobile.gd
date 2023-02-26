extends KinematicBody
class_name BaseMobile

var armature: Armature
onready var ai: StateMachine
var interfaces = [IActor.new(self), IContainer.new(self), INetworked.new(self)]

var velocity := Vector3.ZERO
var force := Vector3.ZERO
var item_list := []
var lock_target = null
var lock_range = 100
var factions = []

func _physics_process(delta):
	ai.cycle()
	move(delta)

func build_from_dictionary(data: Dictionary) -> void:
	for override in data:
		match override:
			"skeleton":
				armature = load("res://mobiles/armatures/"+data.skeleton+"_armature.tscn").instance()
				add_child(armature)
			"equipment":
				for index in data.equipment:
					var item = Data.get_item(index)
					npc("equip", item.as_dict())
					item.queue_free()
			"ai":
				ai = load("res://mobiles/ai/"+data.ai+"/sm_"+data.ai+".tscn").instance()
				add_child(ai)
			"factions":
				for faction in data.factions:
					add_to_group(faction)
					factions.append(faction)
				
				
func move(delta) -> void:
	add_force(Vector3.DOWN)
	if armature.is_using_root_motion():
		var m = armature.get_root_motion().origin
		m = m.rotated(Vector3.UP, armature.rotation.y)
		m *= 2
		velocity = m / delta
	elif is_instance_valid(lock_target):
		armature.face_dir(direction_to(lock_target), delta)
	else:
		armature.face_dir(velocity, delta)
	var final_move = velocity + force
	if final_move.y < 0:
		var _discard = move_and_slide_with_snap(final_move, Vector3.DOWN, Vector3.UP, true)
	else:
		var _d = move_and_slide(final_move, Vector3.UP, true)
	if ! is_dummy():
		var sync_args = {
			"function":"sync_move",
			"update":"", 
			"position":global_transform.origin, 
			"rotation":armature.rotation.y,
			"animation": armature.get_current_animation(), 
			"root_motion": armature.is_using_root_motion(), 
			"uuid":int(name)}
		npc("sync_move", sync_args)
	velocity = Vector3.ZERO
	force = Vector3.ZERO
	
func sync_move(args: Dictionary) -> void:
	if is_dummy():
		if args.has("position"):
			global_transform.origin = args.position
		armature.rotation.y = args.rotation
		if args.animation != armature.get_current_animation() and args.animation != "":
			play(args.animation, args.root_motion)
			
func equip(item_dict: Dictionary) -> void:
	var item = BaseItem.new(item_dict)
	armature.equip(item)
	item.queue_free()
			
			
func get_ledge() -> Vector3:
	return armature.get_ledge()
	
func get_interact_target() -> Spatial:
	return armature.get_interact_target()
	
func toggle_lock_on(group_filter_array=[]) -> void:
	if is_instance_valid(lock_target):
		lock_target = null
	else:
		acquire_next_lock_target(group_filter_array)
			
func acquire_next_lock_target(group_filter_array=[]) -> void:
	var next_target = Vector3.ZERO
	for unit in get_tree().get_nodes_in_group("actors"):
		if unit != self \
			and unit != lock_target \
 			and can_see(unit)\
			and distance_to(unit) < lock_range:
				for group in group_filter_array:
					if unit.is_in_group(group):
						break
				if ! is_instance_valid(lock_target):
					next_target = unit
				elif distance_to(unit) <= distance_to(next_target):
					next_target = unit
	lock_target = next_target
			
func distance_to(target) -> float:
	if target is Spatial:
		target = target.global_transform.origin
	if target is Vector3:
		return global_transform.origin.distance_to(target)
	return 0.0
	
func direction_to(target) -> Vector3:
	if target is Spatial:
		target = target.global_transform.origin
	if target is Vector3:
		return global_transform.origin.direction_to(target)
	return Vector3.ZERO

func get_factions() -> Array:
	return factions
	
func can_see(target) -> bool:
	if target is Spatial:
		return can_see_object(target)
	elif target is Vector3:
		return can_see_point(target)
	else:
		return false
		
func can_see_object(target: Spatial) -> bool:
	var my_pos = armature.global_transform.origin + Vector3(0,2,0)
	var t_pos = target.global_transform.origin + Vector3(0,2,0)
	var result = get_world().direct_space_state.intersect_ray(my_pos, t_pos)
	return target == result.collider
	
func can_see_point(target: Vector3) -> bool:
	var my_pos = armature.global_transform.origin + Vector3(0,2,0)
	var t_pos = target
	var result = get_world().direct_space_state.intersect_ray(my_pos, t_pos)
	return result.empty()
			
##IActor
func emote(anim: String, repeat: bool = true) -> void:
	ai.get_state("Emote").animation = anim
	ai.get_state("Emote").held = repeat
	ai.set_state("Emote")

func set_velocity(v: Vector3) -> void:
	velocity = v

func add_force(f: Vector3) -> void:
	force += f

func play(animation: String, root_motion:bool = false) -> void:
	armature.play(animation, root_motion)
	
func set_state(state):
	ai.set_state(state)
	
##IContainer
func add_item(item: BaseItem) -> void:
	item_list.append(item)
	
func remove_item(removal) -> void:
	if removal is int:
		item_list.remove(removal)
	elif removal is String:
		for i in item_list:
			if i.current.index == removal:
				item_list.erase(i)
				return
	
func get_items() -> Array:
	return item_list

##INetworked
func npc(function: String, args: Dictionary) -> void:
	args["function"] = function
	args["uuid"] = int(name)
	Server.npc(args)
	
func is_dummy() -> bool:
	return int(name) != Client.nid
