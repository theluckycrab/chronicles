extends Ability

var gear = {"Head":"guard_helmet", "Chest":"guard_chest", "Gloves":"guard_gloves", \
		"Legs":"guard_pants", "Boots":"guard_boots", "Mainhand":"katana"}
		
var summon = null
var summonID = null

func _init() -> void:
	index = "Summon Dummy"
	animation = "Taunt"
	priority = 2
	host = null


func enter() -> void:
	keyframe_connect()
	host.connect("tree_exiting", self, "on_host_exit")
	#host.hide_weapon()
	pass


func exit() -> void:
	keyframe_disconnect()
	combat_check()
	completed()
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return host.get_animation() != animation


func execute() -> void:
	pass
	
func on_keyframe():
	if !is_instance_valid(summon):
		create_summon()
	else:
		on_summon_died()
		create_summon()
		
		
		
func on_summon_died():
	summon.net_stats.unregister()
	summon = null
	summonID = null
	

func on_host_exit():
	if summonID != null:
		Network.relay_signal("unregister", {netID=summonID, map=Network.map, notice="summon despawn"})

func create_summon():
	var projectile = Data.get_reference_instance("target_dummy")
	get_viewport().add_child(projectile)
	projectile.stats.faction = "Player"
	projectile.connect("died", self, "on_summon_died")
	var a = Vector3.BACK.rotated(Vector3.UP, host.armature.rotation.y)
	projectile.global_transform.origin = host.global_transform.origin + a
	for i in gear:
		projectile.base_defaults = gear.duplicate(true)
	projectile.armature.weaponbox.damage.tags.append("Player")
	projectile.armature.weaponbox.damage.tags.erase("Dummy")
	summon = projectile
	summonID = projectile.net_stats.netID
	yield(get_tree().create_timer(1), "timeout")
	print("dongetto")
		
