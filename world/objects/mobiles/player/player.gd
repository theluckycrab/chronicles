class_name Player
extends BaseMobile

var hp = 10

func _init() -> void:
	net_init("player")
	base_defaults = {
		"Head":"bandana",
		"Mainhand":"katana",
		"Offhand":"naked_offhand"
	}


func _ready() -> void:
	if net_stats.is_master:
		net_stats.register()
		grab_camera()
	else:
		$UI.queue_free()
	armature.weaponbox.damage.tags.append("Player")
	var _discard = $Hitbox.connect("hitbox_entered", self, "on_got_hit")
	$Hitbox.idle()
	$Hitbox.owner = self
	
	
func on_got_hit(mybox, theirbox):
	var dir = get_hit_dir(mybox, theirbox)
	var zone = get_hit_zone(dir)
	var item = get_equipped(zone)
	if item and !item.has_tag("Default") and item.durability > 0:
		item.durability -= 1
		if item.durability < 1:
			destroy(zone)
		print(item.index, " was struck", item.durability)
	else:
		print("player was struck", hp)
		hp -= 1
		set_state("stagger")
	
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


func hide_weapon():
	armature.hide_weapon()
	
	
func show_weapon():
	armature.show_weapon()
