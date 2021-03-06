class_name Player
extends BaseMobile

var hp = 4

func _init() -> void:
	net_init("player")
	viewers = 1000

func _ready() -> void:
	set_faction({"faction":"Player"})
	var d = Damage.new()
	d.add_tag("Player")
	armature.weaponbox_damage(d)
	var _discard = Events.connect("console_print", self, "on_console_print")
	var _nidscard = Events.connect("net_print", self, "on_net_print")
	if net_stats.is_master:
		grab_camera()
	else:
		$UI.queue_free()
	$Hitbox.idle()
	$Hitbox.owner = self
	$Hitbox.Connect(self)
	
	
func _physics_process(_delta):
	if net_stats.is_master:
		if Input.is_action_just_pressed("inventory"):
			#get_viewport().add_child(Data.get_reference_instance("target_dummy"))
			#Events.emit_signal("scene_change_request", "test_room2")
			$Inventory/InventoryManager.visible = !$Inventory/InventoryManager.visible
			$Inventory/PouchManager.visible = !$Inventory/PouchManager.visible
			#Events.emit_signal("console_print", "System: Why you tryna cheat tho?")
			pass
	
func on_got_hit(theirbox):
	if net_stats.is_master:
		if "Player" in theirbox.damage.tags:
			return
		var dir = get_hit_dir(self, theirbox)
		var zone = get_hit_zone(dir)
		var item = get_equipped(zone.to_lower())
		if item and !item.has_tag("Default") and item.durability > 0:
			consume_durability(item.get_slot())
			$Armature/EffectsPlayer.play("armor_hit")
			if item.durability < 1:
				destroy(zone)
				$Armature/EffectsPlayer.play("armor_break")
			Events.emit_signal("console_print", item.index+" was struck "+str(item.durability))
		else:
			Events.emit_signal("console_print", "player was struck! " + str(hp))
			$Armature/EffectsPlayer.play("hp_hit")
			hp -= 1
			if is_instance_valid($UI/HPBar):
				$UI/HPBar.value = hp
			set_state("stagger")
			if hp < 1:
				on_death()
	
func get_hit_dir(mybox, theirbox):
	var mypos = mybox.global_transform.origin
	var tpos = theirbox.global_transform.origin
	var dir = mypos.direction_to(tpos)
	dir = dir.rotated(Vector3.UP, armature.rotation.y)
	return dir
	
	
func get_hit_zone(dir:Vector3):
	match dir.abs().max_axis():
		Vector3.AXIS_X:
			if dir.x > 0:
				return "mainhand"
			elif dir.x < 0:
				return "offhand"
		Vector3.AXIS_Y:
			if dir.y > 0:
				return "head"
			else:
				return "boots"
		Vector3.AXIS_Z:
			return "HP"
	return "HP"
	
	
func get_can_act() -> bool:
	return !state_machine.get_state() is ActionState\
			and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
		
		
func ui_active() -> bool:
	return $UI.active
	
	
func acquire_lock_target(filter=[]) -> void:
	var cam = get_viewport().get_camera()
	if cam.has_method("acquire_lock_target"):
		lock_target = cam.acquire_lock_target(filter)
	if lock_target:
		self.in_combat = true
		state_machine.set_mode("combat")
	
	
func lock_on() -> void:
	if is_instance_valid(lock_target):
		var dir = global_transform.origin.direction_to(lock_target.global_transform.origin)
		var angle = atan2(dir.x, dir.z)
		var cam = get_viewport().get_camera()
		cam.set_h_rotation(lerp_angle(cam.get_h_rotation(), angle + deg2rad(180), 0.05))
		armature.rotation.y = lerp_angle(armature.rotation.y, angle, 0.2)
	elif self.at_war:
		acquire_lock_target()
		

func net_init(index):
	net_stats = NetStats.new(index)
	net_stats.netID = Network.get_nid()
	net_stats.netOwner = Network.get_nid()
	net_stats.original_instance_id = get_instance_id()
	#net_stats.register()


func hide_weapon(_args={}):
	armature.hide_weapon()
	
	
func show_weapon(_args={}):
	armature.show_weapon()


func play(args) -> void: #state animations are networked
	armature.play(args.animation, args.motion)


func on_blocked(_theirbox):
	$Armature/EffectsPlayer.play("blocked")
	consume_durability("mainhand")

func on_got_blocked(_theirbox):
	Events.emit_signal("console_print", "got blocked!")
	#set_state("stagger")
	
func on_got_parried(_theirbox):
	set_state("stagger")

func on_death():
	Network.rpc("sub_host_migration", net_stats.netID, Data.get_char_value("map"))
	#Network.relay_signal("net_print", {"text":Data.get_char_value("alias")+ " has died!"})
	release_camera()
	net_stats.call_deferred("unregister")
	
	
func on_console_print(text):
	if net_stats.netID != Network.get_nid():
		return
	if text.begins_with("System:"):
		text = text.lstrip("System:")
		armature.print_overhead_system(text)
		
		
func on_net_print(args):
	if args.sender == net_stats.netID:
		armature.print_overhead_chat(args)
	

