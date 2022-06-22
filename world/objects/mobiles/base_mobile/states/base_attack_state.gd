extends ActionState

var weapon = null


func _init() -> void:
	index = "Attack"
	animation = "Sit_Floor"
	priority = 1
	host = null
	
	
func enter() -> void:
	weapon = host.get_equipped("Mainhand")
	if !weapon is Weapon:
		return
	animation = weapon.combo[0]
	host.npc("play", {animation=animation, motion=false})
	var d = Damage.new()
	d.add_tag(host.get_faction())
	d.damage = weapon.damage
	host.armature.weaponbox_damage(d)
	#host.armature.anim.add_animation(animation, load("res://data/assets/Blender/BaseHumanoid/"+animation+".anim"))
	host.lock_on()
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	pass
	
