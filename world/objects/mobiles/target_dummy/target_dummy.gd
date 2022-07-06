extends BaseMobile

var long = ["pursue"]
var mid = ["pursue", "circle", "defend"]
var close = ["attack", "attack", "defend"]
var any = ["warcry", "delay"]
var action_list = []

enum {CLOSE, MID, LONG, NONE}

var hp = 4
var staggers = 0

func _init() -> void:
	var weps = ["katana", "club", "scimitar"]
	var wep = randi() % weps.size() -1
	wep = weps[wep]
	net_init("target_dummy")
	base_defaults = {
			Head = "wizard_hat",
			Mainhand = wep,
			Chest = "shirt",
			Legs = "pants",
			Boots = "sandals",
			Offhand = "fairy_band"
	}
	for i in 3:
		var it = Data.get_random_item()
		if ! "naked" in it.index:
			base_defaults[it.get_slot()] = it.index

func _ready() -> void:
	var _discard = $Timer.connect("timeout", self, "on_tick")
	var _dicks = $StaggerTimer.connect("timeout", self, "on_stagger_timer")
	at_war = true
	$Hitbox.idle()
	var _diskcard = $Hitbox.connect("hitbox_entered", self, "on_got_hit")
	call_deferred("set_state", "patrol")
	set_faction({"faction":"Dummy"})
	armature.weaponbox.damage.tags.append(get_faction())
	
	
func on_tick():
	if can_act and net_stats.is_master and viewers > 0:
		if !is_instance_valid(lock_target) and get_can_act():
			lock_target = null
			call_deferred("set_state", "patrol")
		elif is_instance_valid(lock_target) and get_can_act():
			build_action_list(get_target_range())
			choose_random_action()


func on_got_parried(_mybox, _theirbox) -> void:
	npc("stagger", {}, true)
	
	
func stagger(_args):
	set_state("stagger")
		
func on_stagger_timer():
	staggers = 0

func on_got_hit(mybox, theirbox) -> void:
	if theirbox.damage.tags.has(get_faction()):
		return
	if theirbox.owner is BaseMobile:
		lock_target = theirbox.owner
	var coll_type = Hitbox.get_collision_type(mybox, theirbox)
	match coll_type:
		Hitbox.collision_type.GOT_HIT:
			if net_stats.is_master:
				npc("take_damage", {damage=theirbox.damage.damage})
				if staggers < 2:
					$StaggerTimer.start(1)
					staggers += 1
					state_machine.call_deferred("quit_state")
					call_deferred("set_state", "stagger")
	
func take_damage(args):
	hp -= args.damage
	$Armature/EffectsPlayer.play("hp_hit")
	if hp <= 0:
				if net_stats.is_master:
					net_stats.unregister()
					if randi() % 100 < 20:
						var loot = Data.get_reference_instance("loot_barrel")
						loot.net_stats.original_instance_id = loot.get_instance_id()
						loot.net_stats.register()
						get_viewport().add_child(loot)
						loot.global_transform.origin = global_transform.origin
					
	
func in_range() -> bool:
	var dist = global_transform.origin.distance_to(lock_target.global_transform.origin)
	return dist < 3 and dist > 4
	
	
func in_view() -> bool:
	var list = $Armature/LockOnArea.get_overlapping_bodies()
	return list.has(lock_target)


func get_target_range() -> int:
	if !is_instance_valid(lock_target):
		return NONE
	if lock_target == null:
		return NONE
	var dist = global_transform.origin.distance_to(lock_target.global_transform.origin)
	if dist < 2.25 and dist > 1:
		return CLOSE
	elif dist > 2 and dist < 6:
		return MID
	elif dist > 6:
		return LONG
	return NONE
	
	
func build_action_list(dist:int) -> void:
	action_list.clear()
	action_list.append_array(any)
	match dist:
		CLOSE:
			action_list.clear()
			action_list.append_array(close)
			return
		MID:
			action_list.append_array(mid)
			return
		LONG:
			action_list.append_array(long)
			return
	action_list = ["reposition"]
			
			
func choose_random_action() -> void:
	if state_machine.get_state() == null or state_machine.get_state().can_exit():
		if !action_list.empty() and get_can_act():
			var num = randi() % action_list.size() -1
			call_deferred("set_state", action_list[num])

func hide_weapon(args={}):
	show_weapon(args)
