class_name BaseMobile
extends KinematicBody

var net_stats
var base_defaults = {}

var lock_target = null

var can_act = true setget , get_can_act
var in_combat = false setget set_in_combat, get_in_combat
var at_war = false setget set_war

var stored_delta = 0

onready var state_machine := $StateMachine
onready var armature := $Armature
onready var inventory := $Inventory
onready var buff_list := $BuffList
onready var move := $Movement
onready var stats := $Stats
onready var controls := $Controls


#builtin
func _ready() -> void:
	if net_stats.is_master:
		call_deferred("init_defaults")#to wait for net registration
	
	
func _physics_process(delta) -> void:
	stored_delta = delta
	if net_stats.is_master:
		state_machine.execute()
		#if self.can_act:
			#lock_on()
		if at_war:
			if lock_target == null:
				acquire_lock_target()
		commit_move()
	update()
	
	
#signal_response
func on_armature_blocked():
	print(net_stats.netID, " blocked!")

		
#setget
func get_can_act() -> bool:
	return !state_machine.get_state() is ActionState
			
			
func get_in_combat() -> bool:
	return lock_target != null
	
	
func set_in_combat(t:bool) -> void:
	if t == true:
		in_combat = true
	elif t == false:
		lock_target = null
		
		
func ui_active() -> bool:
	return false
			
			
#move interface
func add_force(force:Vector3) -> void:
	move.add_force(force)
	

func commit_move() -> void:
	move.commit_move()


#state interface
func set_state(state) -> void:#takes strings or nodes
	state_machine.call_deferred("set_state", state)
	
	
func swap_state(slot: String, state_object: Node) -> void:
	state_machine.swap_state(slot, state_object)
	
	
func reset_state(slot: String) -> void:
	state_machine.reset_state(slot)
	
	
#armature interface
func body_face(dir:Vector3) -> void:
	armature.face(dir)
	
	
func play(animation: String, motion: bool =false) -> void:
	armature.play(animation, motion)
	
	
func vis_equip(args:Dictionary) -> void:
	armature.equip(args)
	
	
func get_animation() -> String:
	return armature.get_animation()
	
	
func guard(dir:String) -> void:
	armature.guard(dir)
	
	
func guard_reset() -> void:
	armature.guard_reset()
	
	
func get_hit_origin() -> Vector3:
	return armature.get_hit_origin()
	
	
func get_root_motion() -> Transform:
	return armature.get_root_motion()
	
	
func weaponbox_strike() -> void:
	armature.weaponbox_strike()
	
	
func weaponbox_ghost() -> void:
	armature.weaponbox_ghost()
	
	
func link_hitbox(box) -> void:
	box.connect("hitbox_entered", self, "on_hitbox_entered")
	
	
#inventory interface
func get_defaults_dict() -> Dictionary:
	return inventory.get_defaults_dict()
	
	
func get_default(slot:String) -> Item:
	return inventory.get_default(slot)
	
	
func get_equipped(slot:String) -> Item:
	return inventory.get_equipped(slot)
	
	
func add_item(item:Item) -> void:
	inventory.add_item(item)
	
	
func set_default(slot:String, index:String) -> void:
	inventory.set_default(slot, index)
	
	
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
	
	
func net_init(index:String) -> void:
	net_stats = NetStats.new(index)
	net_stats.netID = Network.nid_gen()
	net_stats.netOwner = Network.get_nid()
	net_stats.original_instance_id = get_instance_id()
	
	
func update() -> void:
	var args = {
			position = global_transform.origin,
			rot = armature.rotation,
			anim = get_animation(),
			anim_motion = armature.is_using_root_motion()
			
	}
	npc("net_sync", args)
	
	
func net_sync(args:Dictionary) -> void:
	if net_stats.is_dummy:
		global_transform.origin = args.position
		armature.rotation = args.rot
		if get_animation() != args.anim and args.anim != "":
			play(args.anim, args.anim_motion)
	
	
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
	lock_target = $Armature/LockOnArea.get_lock_target([self])
	if lock_target:
		self.in_combat = true
		state_machine.set_mode("combat")
	
	
func lock_on() -> void:
	if lock_target:
		var dir = global_transform.origin.direction_to(lock_target.global_transform.origin)
		var angle = atan2(dir.x, dir.z)
		armature.rotation.y = lerp_angle(armature.rotation.y, angle, 0.8)
	
	
func init_defaults() -> void:
	for i in base_defaults:
		set_default(i, base_defaults[i])
		var item = Data.get_item(base_defaults[i])
		equip(item)
