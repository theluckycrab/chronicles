extends PlayerActionState

var keyframe = 0
var weapon = null
var hits = []
var combo = []
var combo_counter = 0
var done = false
var combo_timer = Timer.new()
var combo_grace = 0.5


func _init() -> void:
	index = "Light Attack"
	animation = "Combat_Idle"
	priority = 1
	host = null
	
func _ready():
	combo_timer.one_shot = true
	combo_timer.autostart = false
	add_child(combo_timer)
	combo_timer.connect("timeout", self, "on_combo_timer")
	
func enter() -> void:
	weapon = host.get_equipped("Mainhand")
	if !weapon is Weapon:
		print()
		return
	done = false
	combo_counter = 0
	keyframe = 0
	host.armature.anim.connect("keyframe", self, "on_keyframe")
	combo = weapon.get_combo()
	cycle()
	pass
	
	
func exit() -> void:
	combo_timer.stop()
	host.armature.anim.disconnect("keyframe", self, "on_keyframe")
	host.weaponbox_ghost()
	pass
	
	
func can_exit() -> bool:
	return done and host.get_animation() != animation
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	if combo_counter > combo.size():
		done = true
	if host.get_animation() != animation:
		#host.weaponbox_ghost()
		if combo_timer.is_stopped():
			combo_timer.start(combo_grace)
		if combo_timer.time_left > 0:
			#host.armature.anim.tree.active = false
			if Input.is_action_just_pressed("light_attack"):
				cycle()
	host.lock_on()
	pass
	
	
func cycle():
	if combo_counter < combo.size():
		host.weaponbox_ghost()
		animation = combo[combo_counter]
		host.play({"animation":animation, "motion":true})
		combo_timer.stop()
	combo_counter += 1
	
func on_keyframe() -> void:
	if keyframe < hits.size():
		pass
		#instance_hit_effect(hits[keyframe])
	keyframe += 1
	
	
func instance_hit_effect(hit:PackedScene) -> void:
	var proj = hit.instance()
	host.armature.add_child(proj)
	proj.global_transform.origin = host.get_hit_origin()
	
func on_combo_timer():
	done = true
