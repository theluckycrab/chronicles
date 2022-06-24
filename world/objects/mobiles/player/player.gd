class_name Player
extends BaseMobile

var hp = 4
var registered = false

func _init() -> void:
	net_init("player")
	viewers = 1000

func _ready() -> void:
	set_faction("Player")
	var d = Damage.new()
	d.add_tag("Player")
	armature.weaponbox_damage(d)
	if net_stats.is_master:
		grab_camera()
	else:
		$UI.queue_free()
	$Hitbox.idle()
	$Hitbox.owner = self
	var _discard = $Hitbox.connect("hitbox_entered", self, "on_got_hit")
	
func _physics_process(_delta):
	if net_stats.is_master:
		if Input.is_action_just_pressed("debug"):
			get_viewport().add_child(Data.get_reference_instance("target_dummy"))
			pass
	
func on_got_hit(mybox, theirbox):
	if net_stats.is_master:
		if "Player" in theirbox.damage.tags:
			return
		var dir = get_hit_dir(mybox, theirbox)
		var zone = get_hit_zone(dir)
		var item = get_equipped(zone)
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
				return "Mainhand"
			elif dir.x < 0:
				return "Offhand"
		Vector3.AXIS_Y:
			if dir.y > 0:
				return "Head"
			else:
				return "Boots"
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
		cam.set_h_rotation(lerp_angle(cam.get_h_rotation(), angle + deg2rad(180), 0.08))
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


func on_blocked(_mybox, _theirbox):
	$Armature/EffectsPlayer.play("blocked")
	consume_durability("Mainhand")

func on_got_blocked(_mybox, _theirbox):
	Events.emit_signal("console_print", "got blocked!")
	#set_state("stagger")
	
func on_got_parried(_mybox, _theirbox):
	set_state("stagger")

func on_death():
	Network.rpc("sub_host_migration", net_stats.netID)
	Network.relay_signal("net_print", {"text":Data.get_char_value("alias")+ " has died!"})
	release_camera()
	net_stats.call_deferred("unregister")
	
