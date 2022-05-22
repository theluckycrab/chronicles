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

onready var anim: AnimationPlayer = $Armature/AnimationPlayer
onready var state_machine = $StateMachine
onready var armature = $Armature
onready var inventory = $Inventory
onready var buff_list = $BuffList

#func _unhandled_input(event):
	#controls(event)

func _init() -> void:
	self.netID = Network.get_nid()
	self.net_stats.netOwner = Network.get_nid()
	net_stats.original_instance_id = get_instance_id()


func _ready() -> void:
	net_stats.register()
	#print(net_stats.net_sum())
	if net_stats.netOwner == Network.get_nid():
		grab_camera()
		for i in armature.defaults:
			npc("equip", {source="defaults", index=i})
			npc("equip", {source="inventory", index=0})
	else:
		$UI.visible = false
			

func _physics_process(delta) -> void:
	if net_stats.netID == Network.get_nid():
		item_menu_controls()
		if get_tree().get_nodes_in_group("menus").size() <= 0:
			get_controlled_velocity_wasd()
		stored_delta = delta
		buff_list.process()
		$StateMachine.execute()
		move()
		update()
		

func controls(event:InputEvent):
#	if get_tree().get_nodes_in_group("menus").size() < 1:
#		for i in state_machine.state_dict:
#			if InputMap.has_action(i):
#				if event.is_action_pressed(i):
#					set_state(i)
#					return
#
#	if !state_machine.get_state() is ActionState:
#		##==UI Controls==##
#		if Input.is_action_pressed("destroy_mod"):
#			$UI/EquipmentDisplay.show_destroy()
#			for i in ["head", "mainhand", "offhand", "boots"]:
#				if Input.is_action_just_released(i):
#					$UI/EquipmentDisplay.show_normal()
#					npc("destroy", {index=i.capitalize()})
#		elif Input.is_action_just_released("destroy_mod"):
#			$UI/EquipmentDisplay.show_normal()
#
#		if Input.is_action_pressed("ability_mod"):
#			$UI/EquipmentDisplay.show_activate()
#			for i in ["head", "mainhand", "offhand", "boots"]:
#				if Input.is_action_just_released(i):
#					$UI/EquipmentDisplay.show_normal()
#					npc("activate_item", {source="equipment", index=i.capitalize()})
#		elif Input.is_action_just_released("ability_mod"):
#			$UI/EquipmentDisplay.show_normal()
#
#		for i in ["head", "mainhand", "offhand", "boots"]:
#				if Input.is_action_just_released(i):
#					if (!Input.is_action_pressed("destroy_mod")\
#						and !Input.is_action_pressed("item_mod"))\
#						and (Input.is_action_pressed("ability_mod")\
#						or Input.is_action_just_released("ability_mod")):
#							npc("activate_item", {source="equipment", index=i.capitalize()})
#							return
#	else:
#		$UI/EquipmentDisplay.show_normal()
#		##==End UI Controls==##
	pass
	
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
	
func set_peace() -> void:
	flags.at_war = false
	state_machine.set_peace()


func item_menu_controls():
	var menu = $UI/ItemMenu
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
		
	if Input.is_action_just_released("item_mod"):
		menu.set_category(null)
		
	if menu.current_category == "categories":
		if Input.is_action_just_released("item_scroll_right"):
			menu.set_category(menu.categories[1])
			print("dongers")

	elif menu.current_category == "equipment":
		if Input.is_action_just_released("item_scroll_right"):
			menu.shift("right")
		elif Input.is_action_just_released("item_scroll_left"):
			menu.shift("left")
		elif Input.is_action_just_released("item_scroll_confirm"):
			npc("equip", {source="external", index=menu.items[0].internal.index})
