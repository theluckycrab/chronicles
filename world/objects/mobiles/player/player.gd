extends KinematicBody

var net_stats = NetStats.new("player")

var lock_target = null

var can_act = true setget , get_can_act
var in_combat = false setget set_in_combat, get_in_combat
var at_war = false setget set_war

onready var state_machine = $StateMachine
onready var armature = $Armature
onready var inventory = $Inventory
onready var buff_list = $BuffList
onready var move = $Movement
onready var stats = $Stats
onready var controls = $Controls


#builtin
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
	else:
		$UI.queue_free()
	

func _physics_process(_delta) -> void:
	if net_stats.is_master:
		if can_act:
			state_machine.execute()
		if at_war:
			if lock_target == null:
				acquire_lock_target()
			lock_on()
		commit_move()
	update()
		
		
#setget
func get_can_act() -> bool:
	return !state_machine.get_state() is ActionState\
			and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
			
			
func get_in_combat() -> bool:
	return lock_target != null
	
	
func set_in_combat(t:bool) -> void:
	if t == true:
		in_combat = true
	elif t == false:
		lock_target = null
		
		
func ui_active() -> bool:
	return $UI.active
			
			
#move interface
func add_force(force:Vector3) -> void:
	move.add_force(force)
	

func commit_move() -> void:
	move.commit_move()


#state interface
func set_state(state) -> void:#takes strings or nodes
	state_machine.set_state(state)
	
	
func swap_state(slot: String, state_object: Node) -> void:
	state_machine.swap_state(slot, state_object)
	
	
func reset_state(slot: String) -> void:
	state_machine.reset_state(slot)
	
	
#armature interface
func body_face(dir:Vector3) -> void:
	armature.face(dir)
	
	
func play(animation: String, motion: bool =false) -> void:
	armature.anim.play(animation, motion)
	
	
func vis_equip(args:Dictionary) -> void:
	armature.equip(args)
	
	
func get_animation() -> String:
	return armature.get_animation()
	
	
func guard(dir:String) -> void:
	armature.guard(dir)
	
	
func guard_reset() -> void:
	armature.guard_reset()
	
	
func get_hit_origin():
	return armature.get_hit_origin()
	
	
#inventory interface
func get_defaults_dict() -> Dictionary:
	return inventory.get_defaults_dict()
	
	
func get_default(slot:String) -> Item:
	return inventory.get_default(slot)
	
	
func get_equipped(slot:String) -> Item:
	return inventory.get_equipped(slot)
	
	
#bufflist interface
func add_effect(source, index:String) -> void:#source can be anything
	buff_list.add_effect(source, index)
	
	
func remove_effect(index:String) -> void:
	buff_list.remove_effect(index)
	
	
func remove_passives(source) -> void:#source can be anything
	buff_list.remove_passives(source)
	
	
#controls interface
func get_wasd() -> Vector3:
	return controls.get_wasd()
	
	
func get_wasd_cam() -> Vector3:
	return controls.get_wasd_cam()
	
	
#network interface
func npc(function:String, args:Dictionary) -> void:
	net_stats.npc(function, args)
	#print(args)
	
	
func update() -> void:
	var args = {
			position = global_transform.origin,
			rot = armature.rotation,
			anime = get_animation(),
	}
	npc("net_sync", args)
	
	
func net_sync(args:Dictionary) -> void:
	if net_stats.is_dummy:
		global_transform.origin = args.position
		armature.rotation = args.rot
		if get_animation() != args.anime:
			play(args.anime)
	
	
##commands
func equip(item:Item) -> void:
	npc("vis_equip", {index=item.get_index()})
	inventory.equip(item)
	for i in item.get_list_of_passives():
		add_effect(item, "slow_fall")
	pass
	
	
func destroy(slot:String) -> void:
	var item = get_default(slot)
	if item == null:
		return
	equip(item)
	
	
func activate_item_slot(slot:String) -> void:
	var item = get_equipped(slot)
	if item == null:
		return
	item.activate(self)
	print(item)
	
	
func grab_camera() -> void:
	var cam = get_viewport().get_camera()
	if cam.has_method("set_track_target"):
		cam.set_track_target(self)
	
	
func set_war(t:bool) -> void:
	at_war = t
	if !at_war:
		lock_target = null
		state_machine.set_mode("peace")
	else:
		state_machine.set_mode("combat")
	
	
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
	
