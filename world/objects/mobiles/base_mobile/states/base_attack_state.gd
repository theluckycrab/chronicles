extends ActionState

var keyframe = 0
var weapon = null
var hits = []


func _init() -> void:
	index = "Attack"
	animation = "Sit_Floor"
	priority = 1
	host = null
	
	
func enter() -> void:
	host.armature.anim.connect("keyframe", self, "on_keyframe")
	keyframe = 0
	weapon = host.get_equipped("Mainhand")
	if !weapon is Weapon:
		return
	animation = weapon.combo[0]
	host.armature.anim.add_animation(animation, load("res://data/assets/Blender/BaseHumanoid/"+animation+".anim"))
	host.weaponbox_strike()
	host.lock_on()
	pass
	
	
func exit() -> void:
	host.armature.anim.disconnect("keyframe", self, "on_keyframe")
	host.weaponbox_ghost()
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	pass
	
	
func on_keyframe() -> void:
	if keyframe < hits.size():
		instance_hit_effect(hits[keyframe])
	keyframe += 1
	
	
func instance_hit_effect(hit:PackedScene) -> void:
	var proj = hit.instance()
	host.armature.add_child(proj)
	proj.global_transform.origin = host.get_hit_origin()
