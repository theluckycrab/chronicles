extends State

func _init() -> void:
	priority = 2
	index = "Attack"

func can_enter() -> bool:
	return host.is_on_floor()
	
func can_exit() -> bool:
	return ! host.armature.is_using_root_motion()

func enter() -> void:
	host.grab_keyframe(self)
	host.play("Strong", true)
		
func execute() -> void:
	pass
	
func exit() -> void:
	host.reset_hitboxes()
	pass

func on_keyframe(bone):
	var damage = DamageProfile.new({"strong":3})
	var weapon = host.get_equipped("mainhand")
	if is_instance_valid(weapon): 
		weapon = weapon.get_damage_profile().as_dict()
		for i in weapon:
			damage.add(i, weapon[i])
	host.strike(bone, damage.as_dict())
	
