extends KinematicBody

var velocity = {
				controlled = Vector3.ZERO,
				force = Vector3.ZERO
				}
				
var gravity = {
				active = true,
				base = -9
				}
				
var flags = {
	can_act = true,
	can_move = true,
	in_menu = false,
	at_war = false,
}

var stored_delta = 0
var speed_mult = 5
var net_stats = NetStats.new("player")
var netID setget set_netID, get_netID
var lock_target = null

onready var anim: AnimationPlayer = $Armature/AnimationPlayer
onready var state_machine = $StateMachine
onready var armature = $Armature
onready var inventory = $Inventory
onready var buff_list = $BuffList


func _init() -> void:
	self.netID = Network.get_nid()
	self.net_stats.netOwner = Network.get_nid()
	net_stats.original_instance_id = get_instance_id()


func _ready() -> void:
	net_stats.register()
	if net_stats.netOwner == Network.get_nid():
		grab_camera()
		for i in armature.defaults:
			npc("equip", {source="defaults", index=i})
			npc("equip", {source="inventory", index=0})
	else:
		$UI.visible = false
		$StateMachine/StateDisplay.visible = false
	$Armature/Skeleton/Mainhand/Mainhand/Hitbox.set_owner(self)
			

func _physics_process(delta) -> void:
	if net_stats.netID == Network.get_nid():
		controls()
		if state_machine.get_state() is MoveState or state_machine.get_state() == null:
			get_controlled_velocity_wasd()
		stored_delta = delta
		buff_list.process()
		$StateMachine.execute()
		move()
		update()
		

func controls():
	if !destroy_controls(): #must come first to avoid conflicts with keyboard activate
		if !item_menu_controls():
			if !ability_controls():
				if !state_machine.get_state() is ActionState:
					lock_on_controls()
					state_controls()
	######TEsting
	if Input.is_action_just_pressed("light_attack"):
		print("ATTACKING")
		state_machine.set_state("Light Attack")
	
	
func set_state(state):
	state_machine.set_state(state)
			


func equip(args) -> void:
	var item
	match args.source:
		"inventory":
			item = inventory.items[args.index]
		"defaults":
			if !armature.defaults.has(args.index):
				return
			item = armature.defaults[args.index]
		"external":
			item = Data.get_reference_instance(args.index)
			
	if armature.equipment.has(item.visual.slot) and\
			armature.equipment[item.visual.slot] == item:
		print("Player : ", args.source, " ", args.index, " already equipped")
		return
		
	if armature.equipment.has(item.visual.slot):
		buff_list.remove_passives(armature.equipment[item.visual.slot])
		
	$UI/EquipmentDisplay.call_deferred("refresh")
		
	armature.equip(item)
	buff_list.add_passives(item)
	
	
func destroy(args) -> void:
	equip({source="defaults", index = args.index})
	
	
func activate_item(args) -> void:
	match args.source:
		"equipment":
			armature.activate_item(args)
		"inventory":
			inventory.activate_item(args)
			
			
func add_effect(source, index) -> void:
	buff_list.add_effect(source, index)
	
	
func remove_effect(index) -> void:
	buff_list.remove_effect(index)
			
	
func remove_passives(source) -> void:
	buff_list.remove_passives(source)
	
	
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
	if flags.at_war and lock_target:
		return
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


func npc(function, args) -> void:
	net_stats.npc(function, args)
	#print(args)
	
	
func set_netID(id) -> void:
	net_stats.netID = id
	
	
func get_netID() -> int:
	return net_stats.netID
	

func update() -> void:
	var args = {
			position = global_transform.origin,
			rot = armature.rotation,
			anime = self.anim.current_animation,
	}
	npc("net_sync", args)
	

func net_sync(args) -> void:
	if args.netOwner != Network.get_nid():
		global_transform.origin = args.position
		armature.rotation = args.rot
		if anim.current_animation != args.anime:
			anim.play(args.anime)
			
			
func set_war() -> void:
	flags.at_war = true
	state_machine.set_war()
	speed_mult = 3
	
func set_peace() -> void:
	flags.at_war = false
	state_machine.set_peace()
	lock_target = null
	speed_mult = 5


func item_menu_controls() -> bool:
	var menu = $UI/ItemMenu
	if !Input.is_action_pressed("item_mod"):
		if Input.is_action_just_released("item_mod"):
			menu.set_category(null)
		return false
		
	if Input.is_action_just_pressed("item_mod")\
			and !Input.is_action_pressed("item_category_1")\
			and !Input.is_action_pressed("item_category_2")\
			and !Input.is_action_pressed("item_category_3")\
			and !Input.is_action_pressed("item_category_4"):
		menu.set_category("categories")
	elif Input.is_action_just_pressed("item_category_1"):
		menu.set_category("consumables")
	elif Input.is_action_just_pressed("item_category_2"):
		menu.set_category("equipment")
		
	if menu.current_category == "categories":
		if Input.is_action_just_released("item_scroll_right"):
			menu.set_category(menu.categories[1])

	elif menu.current_category == "equipment":
		if Input.is_action_just_released("item_scroll_right"):
			menu.shift("right")
		elif Input.is_action_just_released("item_scroll_left"):
			menu.shift("left")
		elif Input.is_action_just_released("item_scroll_confirm"):
			npc("equip", {source="external", index=menu.items[0].internal.index})
	return true


func ability_controls() -> bool:
	if !Input.is_action_pressed("ability_mod"):
		if Input.is_action_just_released("ability_mod"):
			$UI/EquipmentDisplay.show_normal()
		return false
	if Input.is_action_pressed("ability_mod"):
		$UI/EquipmentDisplay.show_activate()
		for i in ["head", "mainhand", "offhand", "boots"]:
			if Input.is_action_just_pressed(i):
				if armature.equipment.has(i.capitalize()):
					armature.equipment[i.capitalize()].activate(self)
					$UI/EquipmentDisplay.show_normal()
					return true
	return true

func destroy_controls() -> bool:
	if !Input.is_action_pressed("destroy_mod"):
		if Input.is_action_just_released("destroy_mod"):
			$UI/EquipmentDisplay.show_normal()
		return false
	if Input.is_action_pressed("destroy_mod"):
		$UI/EquipmentDisplay.show_destroy()
		for i in ["head", "mainhand", "offhand", "boots"]:
			if Input.is_action_just_pressed(i):
				npc("destroy", {index=i.capitalize()})
				$UI/EquipmentDisplay.show_normal()
				return true
	return true


func state_controls() -> bool:
	for i in state_machine.state_dict:
		if InputMap.has_action(i):
			if Input.is_action_just_pressed(i):
				set_state(i)
				return true
	return false
	
	
func acquire_lock_target() -> void:
	var cam = get_viewport().get_camera()
	if cam.has_method("acquire_lock_target"):
		lock_target = cam.acquire_lock_target()
	
	
func lock_on() -> void:
	if lock_target:
		var dir = global_transform.origin.direction_to(lock_target.global_transform.origin)
		var angle = atan2(dir.x, dir.z)
		var cam = get_viewport().get_camera()
		cam.set_h_rotation(lerp_angle(cam.get_h_rotation(), angle + deg2rad(180), 1))
		armature.rotation.y = angle
	

func lock_on_controls() -> void:
	if flags.at_war == false:
		return
	if lock_target == null:
		acquire_lock_target()
	lock_on()

func guard(dir):
	$Armature/Guardbox.guard(dir)
	
func guard_reset():
	$Armature/Guardbox.reset()
