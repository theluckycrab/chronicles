extends KinematicBody
class_name BaseMobile

var armature: Armature
onready var ai: StateMachine
onready var buff_list = $BuffList

var velocity := Vector3.ZERO
var force := Vector3.ZERO
var inventory = Inventory.new()
var lock_target = null
var lock_range = 100
var stats = {}

func _physics_process(delta):
	ai.cycle()
	buff_list.tick(delta)
	move(delta)

func build_from_dictionary(data: Dictionary) -> void:
	if data.index == "player":
		if is_dummy():
			data.ai = "dummy"
		else:
			for i in Data.get_char_data():
				data[i] = Data.get_char_value(i)
	else:
		add_to_group("lock_on_targets")
	stats = data.duplicate(true)
	for override in stats:
		match override:
			"skeleton":
				armature = load("res://mobiles/armatures/"+stats.skeleton+"_armature.tscn").instance()
				add_child(armature)
			"equipment":
				for index in stats.equipment:
					var item = Data.get_item(index)
					npc("equip", item.as_dict())
			"ai":
				ai = load("res://mobiles/ai/"+stats.ai+"/sm_"+stats.ai+".tscn").instance()
				add_child(ai)
			"factions":
				for faction in stats.factions:
					add_to_group(faction)
	armature.link_hitboxes()
				
				
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
	inventory.equip(item)
	#inventory.add_item(item)
			
func get_ledge() -> Vector3:
	return armature.get_ledge()
	
func get_grounded():
	return armature.get_grounded()
	
func get_ground_point():
	return armature.get_ground_point()
	
func get_interact_target() -> Spatial:
	return armature.get_interact_target()
	
func toggle_lock_on(group_filter_array=[]) -> void:
	if is_instance_valid(lock_target):
		lock_target = null
	else:
		acquire_next_lock_target(group_filter_array)
			
func acquire_next_lock_target(group_filter_array=[]) -> void:
	var old_lock = lock_target
	for unit in get_tree().get_nodes_in_group("lock_on_targets"):
		if unit != self \
			and unit != old_lock \
 			and can_see(unit)\
			and distance_to(unit) < lock_range:
				for group in group_filter_array:
					if unit.is_in_group(group):
						break
				if distance_to(unit) <= distance_to(lock_target) or (unit != old_lock and old_lock == lock_target):
					lock_target = unit
			
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
	return stats.factions
	
func can_see(target) -> bool:
	if target is Spatial:
		return can_see_object(target)
	elif target is Vector3:
		return can_see_point(target)
	else:
		return false
		
func can_see_object(target: Spatial) -> bool:
	var my_pos = armature.global_transform.origin + Vector3(0,2,0)
	var t_pos = target.global_transform.origin
	var result = get_world().direct_space_state.intersect_ray(my_pos, t_pos)
	return target == result.collider
	
func can_see_point(target: Vector3) -> bool:
	var my_pos = armature.global_transform.origin + Vector3(0,2,0)
	var t_pos = target
	var result = get_world().direct_space_state.intersect_ray(my_pos, t_pos)
	return result.empty()
	
func get_equipped(slot: String):
	if inventory.equipped_items.has(slot):
		return inventory.equipped_items[slot]
	else:
		return null
			
func emote(anim: String, oneshot: bool = false) -> void:
	ai.get_state("Emote").animation = anim
	ai.get_state("Emote").oneshot = oneshot
	ai.set_state("Emote")

func set_velocity(v: Vector3) -> void:
	velocity = v

func add_force(f: Vector3) -> void:
	force += f

func play(animation: String, root_motion:bool = false) -> void:
	armature.play(animation, root_motion)
	
func set_state(state):
	ai.set_state(state)
	
func add_item(item: BaseItem) -> void:
	inventory.add_item(item)
	
func remove_item(item: BaseItem) -> void:
	inventory.remove_item(item)
	
func get_items() -> Array:
	return inventory.get_items()

func npc(function: String, args: Dictionary) -> void:
	if is_instance_valid(get_tree().network_peer) and ! is_dummy():
		args["function"] = function
		args["uuid"] = int(name)
		Server.npc(args)
	else:
		call(function, args)
	
func is_dummy() -> bool:
	return int(name) != Client.nid

func strike(bone: String = "Mainhand", damage: DamageProfile = DamageProfile.new()):
	damage.set_source(int(name))
	armature.strike(bone, damage)

func reset_hitboxes():
	armature.reset_hitboxes()
	
func grab_keyframe(who):
	armature.grab_keyframe(who)
	
func drop_keyframe(who):
	armature.drop_keyframe(who)

func on_got_hit(damage):
	pass

func activate_item(slot):
	var item = inventory.get_equipped(slot)
	if is_instance_valid(item):
		item.activate(self)
	
func highlight(color):
	armature.highlight(color)
	
func add_buff(buff: BaseBuff):
	buff_list.add_buff(buff)
	
func remove_buff(index: String, all_instances = false):
	buff_list.remove_buff(index, all_instances)

func get_buffs():
	return buff_list.get_buffs()
	
func get_state():
	return ai.get_current_state_index()

func as_dict() -> Dictionary:
	var dict = {}
	dict = stats.duplicate(true)
	dict["category"] = "mobile"
	return dict

func body_face_cam():
	armature.rotation.y = get_viewport().get_camera().rotation.y
