extends KinematicBody

var target = null
var lock_target = null

var offset = Vector3(0, 2.5, -5)
var follow_speed = 10
var teleport_distance = 10

var velocity = Vector3.ZERO

onready var controller_id = 0
onready var invert = get_invert()
onready var sens = get_sens()

var last_mouse_relative = Vector2.ZERO
var joypad = false

onready var camera = $Camera

func _ready():
	Data.connect("config_changed", self, "on_config_changed")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	controller_id = event.get_device()
	if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE and event is InputEventMouseMotion:
		last_mouse_relative = event.relative
		joypad = false
		

func _physics_process(delta):
	if last_mouse_relative == Vector2.ZERO:
		last_mouse_relative.x = Input.get_joy_axis(controller_id, 2)
		last_mouse_relative.y = Input.get_joy_axis(controller_id, 3)
		if abs(last_mouse_relative.x) < 0.25 and abs(last_mouse_relative.y) < 0.25 or last_mouse_relative == Vector2.ZERO:
			last_mouse_relative = Vector2.ZERO
		joypad = true
	apply_rotation()
	apply_limits()
	if is_instance_valid(target):
		var dir = direction_to_target()
		var dist = distance_to_target()
		if dist > offset.z:
			global_transform.origin = target.global_transform.origin + offset()
		if ! line_of_sight():
			global_transform.origin = target.global_transform.origin + Vector3(0,2.5,0)
		else:
			move_and_slide(dir * distance_to_target() * 10)
		smooth_reset_zoom(delta)
		last_mouse_relative = Vector2.ZERO
	else:
		target = Simulation.get_map().get_node_or_null(str(Client.nid)+"/Armature")
			
func apply_rotation():
	if joypad:
		last_mouse_relative *= 8
		last_mouse_relative.y *= 0.5
	rotation.y += last_mouse_relative.x * -0.01 * sens.h * self.invert.x
	rotation.x += last_mouse_relative.y * 0.01 * sens.v  * self.invert.y
	pass
	
func apply_limits():
	if is_instance_valid(lock_target) and is_instance_valid(target):
		lock_on()
	if abs(rad2deg(rotation.x) as int % 360) > 50:
		var t = deg2rad(clamp(rad2deg(rotation.x), -50, 50))
		rotation.x = lerp_angle(rotation.x, t, 0.4)
	pass


func direction_to_target():
	return global_transform.origin.direction_to(target.global_transform.origin)

func distance_to_target():
	return global_transform.origin.distance_to(target.global_transform.origin + offset())

func line_of_sight():
	var space = camera.get_world().direct_space_state
	var result = space.intersect_ray(camera.global_transform.origin, target.global_transform.origin + Vector3(0,1,0), [self, target.get_parent()])
	return result.empty() and ! camera.is_position_behind(target.global_transform.origin)

func offset():
	return offset.rotated(Vector3.UP, rotation.y)

func smooth_reset_zoom(delta):
	var x = last_mouse_relative.x
	var y = rad2deg(rotation.x) as int % 360
	if abs(x) > 10:
		offset.z = lerp(offset.z, -5 - abs(x / 3), 0.02)
	elif y < - 10:
		offset.z = lerp(offset.z, -5 - ((abs(rotation_degrees.x) / 3) as int % 360), 0.02)
	elif y > 25:
		offset.y = lerp(offset.y, 4, 0.02)
		offset.z = lerp(offset.z, -5 + abs(y) / 15, 0.02)
	else:
		offset.z = lerp(offset.z, -5, 0.02)
		offset.y = lerp(offset.y, 2.5, 0.02)
		
func set_lock_target(t):
	lock_target = t

func lock_on():
	var mypos = global_transform.origin
	var tpos = lock_target.global_transform.origin
	var half = mypos.distance_to(tpos) / 2
	var dir = mypos.direction_to(tpos)
	rotation.y = lerp_angle(rotation.y, target.rotation.y, 0.99)
	offset.z = lerp(offset.z, -1.5, 0.02)
	offset.y = lerp(offset.y, 1.5, 0.02)

func get_invert():
	var x = Data.get_config_value("invert_x")
	var y = Data.get_config_value("invert_y")
	match x:
		true:
			x = -1
		false:
			x = 1
	match y:
		true:
			y = -1
		false:
			y = 1
	return Vector2(x, y)

func on_config_changed():
	invert = get_invert()
	sens = get_sens()

func get_sens():
	var h = Data.get_config_value("h_sens")
	var v = Data.get_config_value("v_sens")
	return {"h":h, "v":v}
