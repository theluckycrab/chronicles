extends KinematicBody
class_name BaseMobile

var armature: Armature
onready var ai: StateMachine
var interfaces = [IActor.new(self), IContainer.new(self), INetworked.new(self)]

var velocity := Vector3.ZERO
var force := Vector3.ZERO
var item_list := []

func _physics_process(delta):
	ai.cycle()
	move(delta)

func build_from_dictionary(data: Dictionary) -> void:
	for i in data:
		match i:
			"skeleton":
				armature = load("res://mobiles/armatures/"+data.skeleton+"_armature.tscn").instance()
				add_child(armature)
			"equipment":
				for j in data.equipment:
					var item = Data.get_item(j)
					npc("equip", item.as_dict())
					item.queue_free()
			"ai":
				ai = load("res://mobiles/ai/"+data.ai+"/sm_"+data.ai+".tscn").instance()
				add_child(ai)
				
func move(delta) -> void:
	add_force(Vector3.DOWN)
	if armature.is_using_root_motion():
		var m = armature.get_root_motion().origin
		m = m.rotated(Vector3.UP, armature.rotation.y)
		m *= 2
		velocity = m / delta
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
			
			
func get_ledge():
	return armature.get_ledge()
	
func get_interact_target():
	return armature.get_interact_target()
			
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
