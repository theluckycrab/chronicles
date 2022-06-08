extends BaseMobile

var long = ["pursue"]
var mid = ["pursue", "circle"]
var close = ["attack", "defend", "circle"]
var any = ["reposition", "warcry", "delay"]
var action_list = []

enum {CLOSE, MID, LONG, NONE}


func _init() -> void:
	net_init("target_dummy")
	base_defaults = {
			Head = "wizard_hat",
			Mainhand = "scimitar"
	}

func _ready():
	net_stats.register()
	armature.connect("blocked", self, "on_blocked")
	$Hitbox.idle()
	$Hitbox.connect("hitbox_entered", self, "on_got_hit")
	call_deferred("set_state", "patrol")
	
	
func _physics_process(delta):
	if lock_target == null:
		set_state("patrol")
	elif lock_target:
		build_action_list(get_target_distance())
		choose_random_action()
	

func on_blocked():
	set_state("stagger")


func on_got_hit(mybox, theirbox):
	print(theirbox.damage.tags)
	
	
func action():
	if in_range() and in_view():
		set_state("attack")
	pass
	
	
func in_range() -> bool:
	var dist = global_transform.origin.distance_to(lock_target.global_transform.origin)
	return dist < 4 and dist > 3
	
	
func in_view() -> bool:
	var list = $Armature/LockOnArea.get_overlapping_bodies()
	return list.has(lock_target)

func get_target_distance():
	if lock_target == null:
		return NONE
	var dist = global_transform.origin.distance_to(lock_target.global_transform.origin)
	if dist < 5:
		return CLOSE
	elif dist > 4 and dist < 6:
		return MID
	elif dist > 6:
		return LONG
	return NONE
	
	
func build_action_list(dist):
	action_list.clear()
	action_list.append_array(any)
	match dist:
		CLOSE:
			action_list.clear()
			action_list.append_array(close)
		MID:
			action_list.append_array(mid)
		LONG:
			action_list.append_array(long)
#	action_list.clear()
#	action_list.append("circle")
			
			
func choose_random_action():
	if state_machine.get_state() == null or state_machine.get_state().can_exit():
		var num = randi() % action_list.size() -1
		set_state(action_list[num])
		print("chosen action : ", action_list[num])
