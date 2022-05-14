extends KinematicBody

var run_test = PlayerStateRun.new()
var velocity = {
				controlled = Vector3.ZERO,
				force = Vector3.ZERO
				}
				
var gravity = {
				active = true,
				base = -9
				}
var stored_delta = 0
var speed_mult = 5
var net_stats = NetStats.new("player")
var netID setget set_netID, get_netID

onready var anim: AnimationPlayer = $Armature/AnimationPlayer
onready var state_machine = $StateMachine
onready var armature = $Armature
onready var inventory = $Inventory
onready var buff_list = $BuffList

func _init():
	net_stats.original_instance_id = get_instance_id()

func equip(args):
	var item = Network.get_net_object(args.item)
	if armature.equipment.has(item.visual.slot) and\
			armature.equipment[item.visual.slot] == item:
		return
	if armature.equipment.has(item.visual.slot):
		buff_list.remove_passives(armature.equipment[item.visual.slot])
	armature.equip(item)
	buff_list.add_passives(item)

func _ready() -> void:
	Events.emit_signal("register_object", net_stats.net_sum())
	if self.netID != Network.nid():
		$Inventory/Display.visible = false
	var _discard = Events.connect("item_added", self, "on_item_added")
	grab_camera()
#	for i in armature.defaults:
#		npc("equip", {item=armature.defaults[i]})
	
func remove_passives(source):
	buff_list.remove_passives(source)
	
func on_item_added(args):
	if self.netID != args.netID:
		return
	var item = Data.get_reference_instance(args.item)
	item.internal.is_modified = args.is_modified
	inventory.add_item(item, args.count)
	inventory.get_node("Display").clear_list()
	inventory.get_node("Display").build_list(inventory.items)

func _physics_process(delta) -> void:
	stored_delta = delta
	buff_list.process()
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("trash_item"):
		npc("destroy", {slot = "Head"})
	get_controlled_velocity_wasd()
	$StateMachine.execute()
	move()
	
func destroy(args):
	npc("equip", {item = armature.defaults[args.slot]})
	
	
func get_controlled_velocity_wasd() -> void:
	var x = Input.get_action_strength("d") - Input.get_action_strength("a")
	var y = Input.get_action_strength("s") - Input.get_action_strength("w")
	velocity.controlled = Vector3(x, 0, y).normalized() * speed_mult
	
	
func get_controlled_velocity() -> void:
	var left_stick_dead_zone = 0.25
	var x = Input.get_joy_axis(1, JOY_AXIS_0)
	var y = Input.get_joy_axis(1, JOY_AXIS_1)
	
	if abs(x) < left_stick_dead_zone and abs(y) < left_stick_dead_zone:
		velocity.controlled = Vector3.ZERO
		return
		
	velocity.controlled = Vector3(x, 0, y).normalized() * speed_mult


func move() -> void:
	cam_rotate_controlled_velocity()
	apply_gravity()
	apply_movement()
	face_controlled_velocity()
	reset_velocity()
	
	
func cam_rotate_controlled_velocity() -> void:
	var cam = get_viewport().get_camera()
	var cam_rot = Vector3.ZERO
	if cam.has_method("get_h_rotation"):
		cam_rot = cam.get_h_rotation()
	else:
		cam_rot = cam.rotation.y
	velocity.controlled = velocity.controlled.rotated(Vector3.UP, cam_rot)
		
		
func apply_movement() -> void:
	var movement = velocity.controlled + velocity.force
	if velocity.force.y <= 0:
		var _discard = move_and_slide_with_snap(movement, Vector3.DOWN, Vector3.UP, true)
	else:
		var _discard = move_and_slide(movement, Vector3.UP, false)


func apply_gravity() -> void:
	if gravity.active and !is_on_floor():
		velocity.force += Vector3(0,gravity.base, 0)


func face_controlled_velocity() -> void:
	if velocity.controlled == Vector3.ZERO:
		return
	var angle = atan2(velocity.controlled.x, velocity.controlled.z)
	body_face(angle)
	
	
func body_face(targetAngle: float, turnSpeed: float = 0.2) -> void:
	$Armature.rotation.y = lerp_angle($Armature.rotation.y, targetAngle, turnSpeed)
	
	
func grab_camera() -> void:
	var cam = get_viewport().get_camera()
	if cam.has_method("set_track_target"):
		cam.set_track_target(self)
		
		
func add_force(addedForceVector: Vector3) -> void:
	velocity.force += addedForceVector
	
	
func set_controlled_velocity(vel: Vector3) -> void:
	velocity.controlled = vel


func reset_velocity() -> void:
	velocity.controlled = Vector3.ZERO
	velocity.force = Vector3.ZERO
	
	
func animate(animation: String) -> void:
	anim.play(animation)
	
	
func swap_state(slot: String, state_object: Node) -> void:
	state_machine.swap_state(slot, state_object)
	
	
func reset_state(slot: String) -> void:
	state_machine.reset_state(slot)

func npc(function, args):
	net_stats.npc(function, args)
	print(args)
	
func set_netID(id):
	net_stats.netID = id
	
func get_netID():
	return net_stats.netID


func _exit_tree():
	run_test.queue_free()
