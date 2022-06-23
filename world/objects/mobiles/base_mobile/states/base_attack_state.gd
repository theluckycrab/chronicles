extends ActionState

var weapon = null
var combo = []
var combo_counter = 0
var combo_max = 1
var done = false
var combo_grace = 0.4
var attacking = false
var attack_timer = Timer.new()


func _init() -> void:
	index = "Light Attack"
	animation = "Combat_Idle"
	priority = 2
	host = null
	
func _ready():
	add_child(attack_timer)
	attack_timer.one_shot = true
	attack_timer.autostart = false
	attack_timer.connect("timeout", self, "on_attack_timer")
	
	
func enter() -> void:
	weapon = host.get_equipped("Mainhand")
	if !weapon is Weapon:
		return
	combo_max = 1 + randi() % weapon.combo.size()
	done = false
	combo_counter = 0
	combo = weapon.get_combo()
	attacking = false
	on_attack_timer()
	pass
	
	
func exit() -> void:
	host.weaponbox_ghost()
	attack_timer.stop()
	print("exit")
	done = false
	pass
	
	
func can_exit() -> bool:
	return done and host.get_animation() != animation
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	if host.get_animation() != animation and attacking:
		host.armature.anim.tree.active = false
		attacking = false
		attack_timer.start(0.6)
	pass
	


func on_attack_timer():
	if combo_counter < combo_max:
		host.lock_on()
		attacking = true
		animation = combo[combo_counter]
		host.play({"animation":animation, "motion":true})
		print(animation)
		combo_counter += 1
	else:
		done = true
