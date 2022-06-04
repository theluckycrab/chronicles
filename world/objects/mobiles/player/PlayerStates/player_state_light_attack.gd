extends PlayerActionState

var tick = 0
var weapon = null
var effects = []


func _init() -> void:
	index = "Light Attack"
	animation = "Test_LAttack1"
	priority = 1
	host = null
	effects.append(funcref(self, "dicks"))

	
func enter() -> void:
	host.armature.anim.connect("keyframe", self, "on_keyframe")
	tick = 0
	weapon = host.get_equipped("Mainhand")
	animation = weapon.attack.anim
	pass
	
	
func exit() -> void:
	host.armature.anim.disconnect("keyframe", self, "on_keyframe")
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	pass
	
	
func on_keyframe() -> void:
	if tick < effects.size():
		effects[tick].call_func()
	tick += 1
	
	
func dicks() -> void:
	print(weapon.attack)
	var proj = weapon.attack.projectile.instance()
	host.armature.add_child(proj)
