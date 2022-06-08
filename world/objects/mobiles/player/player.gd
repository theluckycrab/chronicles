class_name Player
extends BaseMobile


func _init() -> void:
	net_init("player")
	base_defaults = {
		"Head":"bandana",
		"Mainhand":"scimitar"
	}


func _ready() -> void:
	net_stats.register()
	if net_stats.is_master:
		grab_camera()
	else:
		$UI.queue_free()
		
		
func _physics_process(delta):
	if self.can_act:
		lock_on()
	
	
func get_can_act() -> bool:
	return !state_machine.get_state() is ActionState\
			and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
		
		
func ui_active() -> bool:
	return $UI.active
	
	
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
		cam.set_h_rotation(lerp_angle(cam.get_h_rotation(), angle + deg2rad(180), 0.2))
		armature.rotation.y = lerp_angle(armature.rotation.y, angle, 0.2)
	

func net_init(index):
	net_stats = NetStats.new(index)
	net_stats.netID = Network.get_nid()
	net_stats.netOwner = Network.get_nid()
	net_stats.original_instance_id = get_instance_id()
