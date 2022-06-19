extends BaseMobile

var long = ["pursue"]
var mid = ["pursue", "circle", "defend"]
var close = ["attack", "attack", "attack", "circle", "defend"]
var any = ["warcry", "circle", "delay"]
var action_list = []

enum {CLOSE, MID, LONG, NONE}

var hp = 3


func _init() -> void:
	net_init("target_dummy")
	base_defaults = {
			Head = "wizard_hat",
			Mainhand = "katana",
			Chest = "shirt",
			Legs = "pants",
			Boots = "sandals",
			Offhand = "fairy_band"
	}


func _ready() -> void:
	at_war = true
	$Hitbox.idle()
	var _discard = $Hitbox.connect("hitbox_entered", self, "on_got_hit")
	call_deferred("set_state", "patrol")
	set_faction("Dummy")
	
	
func _physics_process(_delta) -> void:
	if net_stats.is_master:
		if !is_instance_valid(lock_target) and can_act:
			lock_target = null
			set_state("patrol")
		elif is_instance_valid(lock_target):
			build_action_list(get_target_range())
			choose_random_action()
	#else:
		#print(net_stats.netOwner)


func on_got_parried(_mybox, _theirbox) -> void:
	npc("stagger", {}, true)
	print("parried")
	
	
func stagger(_args):
	set_state("stagger")

func on_got_hit(mybox, theirbox) -> void:
	print("dummy struck")
	if theirbox.damage.tags.has(get_faction()):
		return
	if theirbox.owner is BaseMobile:
		lock_target = theirbox.owner
	var coll_type = Hitbox.get_collision_type(mybox, theirbox)
	match coll_type:
		Hitbox.collision_type.GOT_HIT:
			print("got hit for ", theirbox.damage.damage, "\n", hp, " remains")
			hp -= theirbox.damage.damage
			state_machine.quit_state()
			call_deferred("set_state", "stagger")
			if hp <= 0:
				var sword = preload("res://world/objects/generic/world_object.tscn").instance()
				sword.item = "scimitar"
				get_viewport().add_child(sword)
				sword.global_transform.origin = global_transform.origin + Vector3(0,3,0)
				net_stats.unregister()
	
	
func action() -> void:
	if in_range() and in_view():
		set_state("attack")
	
	
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
	if dist < 4 and dist > 1:
		return CLOSE
	elif dist > 3 and dist < 6:
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
		if !action_list.empty():
			var num = randi() % action_list.size() -1
			set_state(action_list[num])
