extends Ability

var gear = ["guard_helmet", "guard_chest", "guard_gloves", \
		"guard_pants", "guard_boots"]
var summon = null

func _init() -> void:
	index = "Summon Dummy"
	animation = "Taunt"
	priority = 2
	host = null


func enter() -> void:
	keyframe_connect()
	#host.hide_weapon()
	pass


func exit() -> void:
	keyframe_disconnect()
	combat_check()
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return host.get_animation() != animation


func execute() -> void:
	pass
	
func on_keyframe():
	if !is_instance_valid(summon):
		var projectile = Data.get_reference_instance("target_dummy")
		get_viewport().add_child(projectile)
		projectile.set_faction("Player")
		projectile.connect("died", self, "on_summon_died")
		projectile.global_transform.origin = host.global_transform.origin + Vector3.FORWARD * 5
		for i in gear:
			projectile.call_deferred("equip", Data.get_item(i))
		var w = Data.get_item("katana").duplicate()
		w.combo[0] = "Katana_Combo_2"
		projectile.call_deferred("equip", w)
		summon = projectile
		
		
func on_summon_died():
	summon = null
