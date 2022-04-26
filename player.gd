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

onready var anim: AnimationPlayer = $Armature/AnimationPlayer
onready var state_machine = $StateMachine
onready var inventory = Inventory.new()
onready var skeleton = $Armature/Skeleton


func _ready() -> void:
	grab_camera()


func _physics_process(delta) -> void:
	stored_delta = delta
	if Input.is_action_just_pressed("sprint"):
		if $StateMachine.state_dict["Walk"] == run_test:
			reset_state("Walk")
		else:
			swap_state("Walk", run_test)
	if Input.is_action_just_pressed("item"):
		#inventory.get_item().execute(self)
		var i = TestItem.new()
		i.stats.item_name = "Dicks"
		i.stats.is_modified = true
		inventory.add_item(i, 2)
		update_item_display()
		print(inventory.items)
	if Input.is_action_just_pressed("trash_item"):
		inventory.remove_item("Dicks")
		update_item_display()
	inventory.controls()
	get_controlled_velocity_wasd()
	$StateMachine.execute()
	move()
	
	
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
	
	
func body_face(targetAngle:float, turnSpeed:float = 0.2) -> void:
	$Armature.rotation.y = lerp_angle($Armature.rotation.y, targetAngle, turnSpeed)
	
	
func grab_camera() -> void:
	var cam = get_viewport().get_camera()
	if cam.has_method("set_track_target"):
		cam.set_track_target(self)
		
		
func add_force(addedForceVector:Vector3) -> void:
	velocity.force += addedForceVector
	
	
func set_controlled_velocity(vel:Vector3) -> void:
	velocity.controlled = vel


func reset_velocity() -> void:
	velocity.controlled = Vector3.ZERO
	velocity.force = Vector3.ZERO
	
	
func animate(animation) -> void:
	anim.play(animation)
	
	
func swap_state(slot:String, state_object:Node) -> void:
	state_machine.swap_state(slot, state_object)
	
	
func reset_state(slot:String) -> void:
	state_machine.reset_state(slot)
	

func equip_item(item_data) -> Node:
	var item = preload("res://test_item.tscn").instance()
	item.set_script(load("res://test_item.gd"))
	item.mesh = load(item_data.mesh_file_path)
	$Armature.add_child(item)
	item.set_skeleton(skeleton.get_path())
	item.material_override = SpatialMaterial.new()
	item.material_override.albedo_color = Color.purple
	return item


func update_item_display() -> void:
	var list = inventory.items
	var display = $ItemList
	for i in display.get_children():
		i.queue_free()
	for i in list:
		i = i.stats
		var label = Label.new()
		display.add_child(label)
		label.text = i.item_name + str(i.count)
