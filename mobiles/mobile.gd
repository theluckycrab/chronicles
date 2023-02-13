extends KinematicBody
class_name BaseMobile

"""
	BaseMobile represents any creature in the game world that animates through an Armature and 
		chooses behavior using a StateMachine. Mobile is the high-level object that will receive 
		networked function calls from other high-level objects in the game world. None of the 
		children of BaseMobile should ever be touched directly by another object. BaseMobile exists 
		to act as a reliable API for the world to interact with a creature. The children 
		(Armature, StateMachine) are implementation details and are subject to change.
		
	Dependency : Armature, StateMachine, IActor, IContainer
	Setup :
		- Armature
		- StateMachine
"""

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
					npc("equip", {"base_item":j})
			"ai":
				ai = load("res://mobiles/ai/"+data.ai+"/sm_"+data.ai+".tscn").instance()
				add_child(ai)
				
func move(delta) -> void:
	add_force(Vector3.DOWN)
	var _d = move_and_slide(velocity + force, Vector3.UP, true)
	armature.face_dir(velocity, delta)
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
			
func equip(args: Dictionary) -> void:
	armature.equip(Data.get_item(args.base_item))
			
			
##IActor
func emote(e: String) -> void:
	ai.get_state("Emote").animation = e
	ai.set_state("Emote")

func set_velocity(v: Vector3) -> void:
	velocity = v

func add_force(f: Vector3) -> void:
	force += f

func play(animation: String, root_motion:bool = false) -> void:
	armature.play(animation, root_motion)
	
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
