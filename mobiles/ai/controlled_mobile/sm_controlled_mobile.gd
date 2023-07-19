extends StateMachine

var input_locks = 0
var lock_on_view_angle = 60
var controller_id = 0
onready var camera = get_viewport().get_camera()
onready var state_label = $Label

var wasd: Vector3 = Vector3.ZERO

func _ready():
	var _dis = Events.connect("ui_opened", self, "change_input_locks", [1])
	var _card = Events.connect("ui_closed", self, "change_input_locks", [-1])
	
func change_input_locks(c: int):
	input_locks += c
	
func set_wasd():
	wasd.x = Input.get_action_strength("a") - Input.get_action_strength("d")
	wasd.z = Input.get_action_strength("w") - Input.get_action_strength("s")
	
	if wasd == Vector3.ZERO:
		wasd.x = -round(Input.get_joy_axis(controller_id, 0))
		wasd.z = -round(Input.get_joy_axis(controller_id, 1))

func get_wasd() -> Vector3:
	return wasd
	
func get_wasd_cam() -> Vector3:
	return get_wasd().normalized().rotated(Vector3.UP, camera.rotation.y)
	
func _process(_delta):
	if is_instance_valid(current_state):
		state_label.text = current_state.index
	else:
		state_label.text = "No State"
	host.get_interact_target()

func _unhandled_input(event):
	controller_id = event.get_device()
	wasd = Vector3.ZERO
	if !can_act():
		return
	set_wasd()
	if hybrid_input(event):
		return
	if combat_input(event):
		return
	if peace_input(event):
		return
			
	

func can_act() -> bool:
	return input_locks == 0

func clear_lock_target_outside_cam_view() -> void:
	if is_instance_valid(host.lock_target):
		var dir = host.direction_to(host.lock_target)
		var cam_dir = Vector3.BACK.rotated(Vector3.UP, camera.rotation.y)
		if dir.angle_to(cam_dir) > deg2rad(lock_on_view_angle):
			host.toggle_lock_on()
			host.toggle_lock_on(host.get_factions())

func hybrid_input(event):
	if Input.is_action_just_pressed("interact"):
		var target = host.get_interact_target()
		if is_instance_valid(target):
			target.interact(host)
			return true
	elif event.is_action_pressed("draw"):
		set_state("Draw")
		return true
	elif event.is_action_pressed("activate_mainhand"):
		host.activate_slot("mainhand")
		return true
	elif event.is_action_pressed("activate_offhand"):
		host.activate_slot("offhand")
		return true
	elif event.is_action_pressed("activate_boots"):
		host.activate_slot("boots")
		return true
	elif event.is_action_pressed("activate_helm"):
		host.activate_slot("helm")
		return true
	elif event.is_action_pressed("debug"):
		#host.remove_buff("debug")
		#host.add_buff(Data.get_buff("debug"))
		#host.activate_item("head")
		for i in host.get_items():
			host.npc("equip", i.as_dict())
		#set_state("Downed")
		return true
	elif event.is_action_pressed("toggle_sight"):
		host.activate_item("head")
		return true
	return false
	
func combat_input(event):
	if ! host.weapon_drawn:
		return false
	elif event.is_action_pressed("combo"):
		if ! host.is_on_floor():
			host.set_state("FallingAttack")
		else:
			host.set_state("Combo")
		return true
	elif event.is_action_pressed("strong"):
		host.set_state("Strong")
		return true
	elif event.is_action_pressed("jump"):
		set_state("Sidestep")
		return true
	elif event.is_action_pressed("block"):
		set_state("Block")
		return true
	return false
	
func peace_input(event):
	if host.weapon_drawn:
		return false
	if event.is_action_pressed("jump"):
		set_state("Jump")
	return false
