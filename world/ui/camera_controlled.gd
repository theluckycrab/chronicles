extends ClippedCamera

var transform_target = null
var right_stick_vector := Vector2.ZERO
var mouse_motion_vector := Vector2.ZERO
var right_stick_dead_zone: float = 0.25
var h_speed: float = 2.75
var v_speed: float = 2.75
var v_look_limit_degrees: int = 35
var track_speed: float = 0.1
var active: bool = true
var auto_timer = Timer.new()
var auto = false
onready var h = get_parent().get_parent()
onready var v = get_parent()


func _input(event) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			mouse_motion_vector = event.relative
		else:
			mouse_motion_vector = Vector2.ZERO
			right_stick_vector.x = Input.get_joy_axis(1, JOY_AXIS_2)
			right_stick_vector.y = Input.get_joy_axis(1, JOY_AXIS_3)
		apply_mouse_look_limit()
		apply_rotation(mouse_motion_vector, Vector2(0.2, 0.2))
	


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	auto_timer.autostart = false
	auto_timer.one_shot = true
	add_child(auto_timer)
	auto_timer.connect("timeout", self, "on_auto_timer")


func _process(_delta) -> void:
	if is_instance_valid(transform_target):
		track_target()
		calc_rotation()
		if right_stick_vector != Vector2.ZERO:
			apply_rotation(right_stick_vector, Vector2(h_speed, v_speed))
			auto = false
			auto_timer.stop()
			return
			
		if transform_target.get_wasd() == Vector3.ZERO:
			auto = false
			auto_timer.stop()
			
		elif transform_target.get_wasd() != Vector3.ZERO and auto_timer.is_stopped():
			auto_timer.start(1.5)
			
		if right_stick_vector == Vector2.ZERO \
				and !transform_target.ui_active() \
				and transform_target.get_wasd() != Vector3.ZERO\
				and auto:
			var arm = transform_target.armature.rotation.y
			var angle = lerp_angle(get_h_rotation(), arm + deg2rad(180), 0.02)
			set_h_rotation(angle)
	
	
func calc_rotation() -> void:
	apply_right_stick_dead_zone()
	apply_look_limit()
	
	
func apply_right_stick_dead_zone() -> void:
	if abs(right_stick_vector.x) < right_stick_dead_zone:
		right_stick_vector.x = 0
	if abs(right_stick_vector.y) < right_stick_dead_zone:
		right_stick_vector.y = 0
		
		
func apply_look_limit() -> void:
	var y = rad2deg(v.rotation.x) + right_stick_vector.y
	if y > v_look_limit_degrees * .25 and sign(right_stick_vector.y) == -1:
		right_stick_vector.y = 0
	elif y < -v_look_limit_degrees and sign(right_stick_vector.y) == 1:
		right_stick_vector.y = 0
		
func apply_mouse_look_limit() -> void:
	var y = rad2deg(v.rotation.x) + mouse_motion_vector.y
	if y > v_look_limit_degrees * .25 and sign(mouse_motion_vector.y) == -1:
		mouse_motion_vector.y = 0
	elif y < -v_look_limit_degrees and sign(mouse_motion_vector.y) == 1:
		mouse_motion_vector.y = 0
		
		
func apply_rotation(direction_vector:Vector2, speed_vector:Vector2) -> void:
	var angles = Vector2(h.rotation_degrees.y, v.rotation_degrees.x)
	var movement = direction_vector
	angles.x = deg2rad(angles.x)
	angles.y = deg2rad(angles.y)
	movement.x = deg2rad(movement.x)
	movement.y = deg2rad(movement.y)
	angles.x = lerp_angle(angles.x, angles.x + movement.x, -speed_vector.x)
	angles.y = lerp_angle(angles.y, angles.y + movement.y, -speed_vector.y)
	h.rotation.y = angles.x
	v.rotation.x = angles.y
	
	
func get_h_rotation() -> float:
	return h.rotation.y
	
	
func get_v_rotation() -> float:
	return v.rotation.x
	
	
func get_rotation() -> Vector3:
	return Vector3(h.rotation.y, v.rotation.x, 0)
	
	
func _get(property):
	if property == "rotation":
		return Vector3(h.rotation.y, v.rotation.x, 0)


func track_target() -> void:
	if !transform_target:
		return
	var position:Vector3 = h.global_transform.origin
	var newPosition:Vector3 = transform_target.global_transform.origin
	h.global_transform.origin = position.linear_interpolate(newPosition, track_speed)
	
	
func set_track_target(who) -> void:
	if !is_instance_valid(who):
		return
	transform_target = who
	add_exception(who)
	

func acquire_lock_target(ignores):
	var filter := []
	if !ignores is Array:
		filter.append(ignores)
	else:
		filter.append_array(ignores)
	filter.append(transform_target)
	return $LockOnArea.get_lock_target(filter, "Player")
	
	
func get_r_stick():
	return right_stick_vector


func set_h_rotation(angle):
	h.rotation.y = angle
	
	
func set_v_rotation(angle):
	v.rotation.x = angle


func on_auto_timer():
	auto = true
