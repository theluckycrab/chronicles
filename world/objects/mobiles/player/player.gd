extends KinematicBody

var net_stats = NetStats.new("player")

var lock_target = null

var can_act = true setget , can_act
var in_combat = false setget set_in_combat, get_in_combat
var at_war = false setget set_war

onready var state_machine = $StateMachine
onready var armature = $Armature
onready var inventory = $Inventory
onready var buff_list = $BuffList
onready var move = $Movement
onready var stats = $Stats
onready var controls = $Controls


func _init() -> void:
	net_stats.netID = Network.get_nid()
	net_stats.netOwner = Network.get_nid()
	net_stats.original_instance_id = get_instance_id()


func _ready() -> void:
	net_stats.register()
	var defaults = get_defaults_dict()
	if net_stats.is_master:
		grab_camera()
		for i in defaults:
			equip(defaults[i])
	

func _physics_process(delta) -> void:
	if net_stats.is_master:
		if can_act:
			state_machine.execute()
		if at_war:
			if lock_target == null:
				acquire_lock_target()
			lock_on()
		move()
	update()
		
		
func add_force(force):
	move.add_force(force)


func can_act():
	return !state_machine.get_state() is ActionState\
			and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


func set_state(state):
	state_machine.set_state(state)
			


func equip(item) -> void:
	npc("vis_equip", {index=item.internal.index})
	inventory.equip(item)
	for i in item.passive:
		add_effect(item, "slow_fall")
	pass
	
func vis_equip(args) -> void:
	armature.equip(args)
	
	
func destroy(slot) -> void:
	var item = get_default(slot)
	if item == null:
		return
	equip(item)
	
	
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
	
	
func get_wasd():
	return controls.get_wasd()
	
func get_wasd_cam():
	return controls.get_wasd_cam()
	
func body_face(dir):
	armature.face(dir)

func move() -> void:
	move.commit_move()
	
	
func grab_camera() -> void:
	var cam = get_viewport().get_camera()
	if cam.has_method("set_track_target"):
		cam.set_track_target(self)
	
	
func play(animation: String, motion=false) -> void:
	armature.anim.play(animation, motion)
	
	
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
			anime = get_animation(),
	}
	npc("net_sync", args)
	

func net_sync(args) -> void:
	if net_stats.is_dummy:
		global_transform.origin = args.position
		armature.rotation = args.rot
		if get_animation() != args.anime:
			play(args.anime)
			
func get_animation():
	return armature.get_animation()
			
			
func set_war(t) -> void:
	at_war = t
	if !at_war:
		lock_target = null
		state_machine.set_mode("peace")
	else:
		state_machine.set_mode("combat")

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
	if lock_target:
		self.in_combat = true
		state_machine.set_mode("combat")
	
	
func lock_on() -> void:
	if lock_target:
		var dir = global_transform.origin.direction_to(lock_target.global_transform.origin)
		var angle = atan2(dir.x, dir.z)
		var cam = get_viewport().get_camera()
		cam.set_h_rotation(lerp_angle(cam.get_h_rotation(), angle + deg2rad(180), 1))
		armature.rotation.y = angle
	

func lock_on_controls() -> void:
	acquire_lock_target()
	lock_on()

func guard(dir):
	$Armature/Guardbox.guard(dir)
	
func guard_reset():
	$Armature/Guardbox.reset()

func get_defaults_dict():
	return inventory.get_defaults_dict()
	
	
func get_default(slot):
	return inventory.get_default(slot)
	
func get_in_combat():
	return lock_target != null
	
func set_in_combat(t):
	if t == true:
		in_combat = true
	elif t == false:
		lock_target = null
