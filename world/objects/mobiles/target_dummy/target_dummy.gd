extends BaseMobile

var long = ["pursue"]
var mid = ["pursue", "circle"]
var close = ["attack"]
var any = ["warcry", "circle", "delay"]
var action_list = []

enum {CLOSE, MID, LONG, NONE}

var hp = 1


func _init() -> void:
	net_init("target_dummy")
	base_defaults = {
			Head = "wizard_hat",
			Mainhand = "scimitar"
	}

func _ready():
	net_stats.register()
	$Hitbox.idle()
	$Hitbox.connect("hitbox_entered", self, "on_got_hit")
	call_deferred("set_state", "patrol")
	
	
func _physics_process(delta):
	if lock_target == null:
		set_state("patrol")
	elif lock_target:
		build_action_list(get_target_distance())
		choose_random_action()
	

func on_blocked(_mybox, _theirbox):
	print("incoming : ")

func on_got_parried(_mybox, _theirbox):
	set_state("stagger")

func on_got_hit(mybox, theirbox):
	if !theirbox.damage.tags.has("Player"):
		return
	var coll_type = Hitbox.get_collision_type(mybox, theirbox)
	match coll_type:
		Hitbox.collision_type.GOT_HIT:
			hp -= theirbox.damage.damage
			set_state("stagger")
			if hp <= 0:
				if theirbox.damage.tags.has("Sher"):
					var sword = preload("res://world/objects/generic/world_object.tscn").instance()
					sword.item = "scimitar"
					get_viewport().add_child(sword)
					sword.global_transform.origin = global_transform.origin + Vector3(0,3,0)
				queue_free()
	
	
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
	if dist < 4 and dist > 2:
		return CLOSE
	elif dist > 3 and dist < 6:
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
			return
		MID:
			action_list.append_array(mid)
			return
		LONG:
			action_list.append_array(long)
			return
	action_list = ["reposition"]
			
			
func choose_random_action():
	if state_machine.get_state() == null or state_machine.get_state().can_exit():
		var num = randi() % action_list.size() -1
		set_state(action_list[num])
		#print("chosen action : ", action_list[num])
