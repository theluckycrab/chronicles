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
		apply_rotation(mouse_motion_vector, Vector2(0.2, 0.2))
	


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta) -> void:
	track_target()
	calc_rotation()
	if right_stick_vector != Vector2.ZERO:
		apply_rotation(right_stick_vector, Vector2(h_speed, v_speed))
	
	
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
	transform_target = who
	

func acquire_lock_target():
	return $LockOnArea.get_lock_target()


func set_h_rotation(angle):
	h.rotation.y = angle
	
	
func set_v_rotation(angle):
	v.rotation.x = angle
