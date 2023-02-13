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
var interfaces = [IActor.new(self), IContainer.new(self)]

var velocity := Vector3.ZERO
var force := Vector3.ZERO
var item_list := []

func _ready():
	build_from_dictionary(Data.get_mobile_data("player"))

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
					armature.equip(Data.get_item(j))
			"ai":
				ai = load("res://mobiles/ai/"+data.ai+"/sm_"+data.ai+".tscn").instance()
				add_child(ai)
				
func move(delta) -> void:
	add_force(Vector3.DOWN)
	var _d = move_and_slide(velocity + force, Vector3.UP, true)
	armature.face_dir(velocity, delta)
	velocity = Vector3.ZERO
	force = Vector3.ZERO
				
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
