extends Node
class_name BaseAbility

var current: Dictionary
var raw: Dictionary
var state = null
var active = false

func _init(data: Dictionary) -> void:
	raw = data
	current = raw
	if current.effects.has("state"):
		var n = Node.new()
		n.set_script(load("res://mobiles/ai/controlled_mobile/states/abilities/"+current.effects.state+".gd"))
		state = n
		
	
func execute(host) -> void:
	if ! check_requirements(host):
		return
	if !is_instance_valid(state):
		host.emote(current.animation, false)
	active = !active
	host.body_face_cam()
		
	for i in current.effects:
		match i:
			"buff":
				buff(host, current.effects[i])
			"state":
				host.set_state(state)
			"projectile":
				var p = load("res://generics/base_projectile.tscn").instance()
				p.build_from_dictionary(current.effects.projectile)
				p.set_source(int(host.name))
				var position = host.global_transform.origin + Vector3(0,0,-1).rotated(Vector3.UP, host.armature.rotation.y)
				Simulation.spawn(p, position, host.armature.rotation.y)

func check_requirements(host):
	for i in current.requirements:
		match i:
			"grounded":
				if !host.is_on_floor():
					return false
			"ungrounded":
				if host.is_on_floor():
					return false
	return true
	
func buff(host, entry):
	if !active and current.type == "sight":
		host.remove_buff(entry)
	else:
		host.add_buff(Data.get_buff(entry))

func as_dict() -> Dictionary:
	var dict = current.duplicate(true)
	return dict
