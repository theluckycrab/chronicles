extends State

var used = false

func _init() -> void:
	priority = 3
	index = "Falling_Attack"

func can_enter() -> bool:
	return ! host.is_on_floor() and ! used
	
func can_exit() -> bool:
	return ! host.armature.is_using_root_motion()

func enter() -> void:
	used = true
	host.grab_keyframe(self)
	host.play("Fist_Falling", true)
		
func execute() -> void:
	host.add_force(Vector3.DOWN * 3)
	pass
	
func exit() -> void:
	host.drop_keyframe(self)
	host.reset_hitboxes()
	pass

func on_keyframe(bone):
	var damage = DamageProfile.new({"strong":3})
	var weapon = host.get_equipped("mainhand")
	if is_instance_valid(weapon): 
		weapon = weapon.get_damage_profile().as_dict()
		for i in weapon:
			damage.add(i, weapon[i])
	host.strike(bone, damage)
	
func _physics_process(delta):
	if host.is_on_floor():
		used = false
	
