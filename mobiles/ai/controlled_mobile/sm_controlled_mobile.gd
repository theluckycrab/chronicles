extends StateMachine

var input_locks = 0
var lock_on_view_angle = 60
onready var camera = $ControlledCamera
onready var state_label = $Label

var wasd: Vector3 = Vector3.ZERO

func _ready():
	var _dis = Events.connect("ui_opened", self, "change_input_locks", [1])
	var _card = Events.connect("ui_closed", self, "change_input_locks", [-1])
	
func change_input_locks(c: int):
	input_locks += c

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
	wasd = Vector3.ZERO
	if !can_act():
		return
	if is_instance_valid(host.get_interact_target()) and event.is_action_pressed("jump"):
		host.get_interact_target().interact(host)
		return
	elif event.is_action_pressed("jump"):
		set_state("Jump")
	elif event.is_action_pressed("tab"):
		host.toggle_lock_on(host.get_factions())
		clear_lock_target_outside_cam_view()
		camera.set_lock_target(host.lock_target)
	elif event.is_action_pressed("q"):
		host.acquire_next_lock_target(host.get_factions())
		clear_lock_target_outside_cam_view()
		camera.set_lock_target(host.lock_target)
	elif event.is_action_pressed("combo"):
		host.set_state("Combo")
	elif event.is_action_pressed("strong"):
		host.set_state("Strong")
	if event.is_action_pressed("debug"):
		#host.remove_buff("debug")
		#host.add_buff(Data.get_buff("debug"))
		#host.activate_item("head")
		for i in host.get_items():
			host.npc("equip", i.as_dict())
	if event.is_action_pressed("toggle_sight"):
		host.activate_item("head")
			
	wasd.x = Input.get_action_strength("a") - Input.get_action_strength("d")
	wasd.z = Input.get_action_strength("w") - Input.get_action_strength("s")
	
	if wasd == Vector3.ZERO:
		wasd.x = -round(Input.get_joy_axis(1, 0))
		wasd.z = -round(Input.get_joy_axis(1, 1))

func can_act() -> bool:
	return input_locks == 0

func clear_lock_target_outside_cam_view() -> void:
	if is_instance_valid(host.lock_target):
		var dir = host.direction_to(host.lock_target)
		var cam_dir = Vector3.BACK.rotated(Vector3.UP, camera.rotation.y)
		if dir.angle_to(cam_dir) > deg2rad(lock_on_view_angle):
			host.toggle_lock_on()
			host.toggle_lock_on(host.get_factions())
