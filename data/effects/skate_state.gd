extends State

var dir = Vector3.ZERO
var speed = 15

func _init() -> void:
	index = "Walk"
	animation = "Dash"
	priority = 1
	host = null


func enter() -> void:
	print("skating?")
	dir = host.get_wasd_cam()
	pass


func exit() -> void:
	pass


func can_enter() -> bool:
	return true


func can_exit() -> bool:
	return false


func execute() -> void:
	host.add_force(dir * speed)
	host.body_face(dir * speed)
	if Input.is_action_just_pressed("light_attack"):
		host.npc("show_weapon", {})
		host.weaponbox_strike()
		host.at_war = true
		host.set_state("dodge_attack")
	pass
