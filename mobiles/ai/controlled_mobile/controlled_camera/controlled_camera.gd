extends Spatial

"""
	The ControlledCamera is a complicated rig requiring a particular setup. As it handles its own
		input, you'll need to manage when it can and can't act. ui_cancel (Escape) will toggle the
		visibility of the cursor by default. Page up and down will invert the axis. The Controlled
		Camera supports both mouse and joypad inputs (right stick). 
		
	Dependencies :
	Setup : 
		- Self
			- SpringArm named Vertical
				- Camera named Camera
		- Set SpringArm height
"""

var last_mouse_relative = Vector2.ZERO
var h_sens = 0.25
var v_sens = 0.25
var v_invert = -1
var h_invert = 1
var min_v_angle = deg2rad(-25)
var max_v_angle = deg2rad(25)
var views = []
var stored_delta = 0
var lock_target = null
export var spring_length = 4
export var spring_height = 2.2
export var h_offset = 0.05
export var fov = 90

onready var vertical_pivot = $Vertical
onready var camera = $Vertical/Camera

func _ready():
	setup()

func _input(event):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE and event is InputEventMouseMotion:
		last_mouse_relative = event.relative
		apply_rotation()
		apply_limits()

	if event.is_action_released("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if event.is_action_released("ui_page_up"):
		v_invert *= -1
	if event.is_action_released("ui_page_down"):
		h_invert *= -1

func _process(_delta):
	if is_instance_valid(lock_target):
		var dir = global_transform.origin.direction_to(lock_target.global_transform.origin)
		var angle = atan2(dir.x, dir.z)
		rotation.y = lerp_angle(rotation.y, angle, 0.8)
	if last_mouse_relative == Vector2.ZERO:
		last_mouse_relative.x = Input.get_joy_axis(1, 2)
		last_mouse_relative.y = Input.get_joy_axis(1, 3)
		if abs(last_mouse_relative.x) < 0.25 and abs(last_mouse_relative.y) < 0.25 or last_mouse_relative == Vector2.ZERO:
			last_mouse_relative = Vector2.ZERO
			return
		apply_rotation(true)
		apply_limits()
	
	
func build_views():
	for i in get_children():
		if i is Position3D:
			views.append(i)
		
		
func change_view(v):
	if v >= views.size():
		return
	camera.global_transform = views[v].global_transform
	camera.rotation.y = deg2rad(-180)
	rotation.y = views[v].rotation.y

func apply_rotation(joypad=false):
	var hmod = h_sens
	var vmod = v_sens
	if joypad:
		hmod *= 10
		vmod *= 10
	rotation.y = lerp_angle(rotation.y, rotation.y - deg2rad(last_mouse_relative.x), hmod * h_invert)
	vertical_pivot.rotation.x = \
			lerp_angle(vertical_pivot.rotation.x,\
			 vertical_pivot.rotation.x - deg2rad(last_mouse_relative.y),\
			 vmod * v_invert)
	last_mouse_relative = Vector2.ZERO
	
func apply_limits():
	vertical_pivot.rotation.x = clamp(vertical_pivot.rotation.x, min_v_angle, max_v_angle)
	
func set_lock_target(t):
	lock_target = t

func setup():
	build_views()
	change_view(0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.h_offset = h_offset
	camera.fov = fov
	camera.far = 2000
	camera.rotation_degrees.y = -180
	camera.current = true
	vertical_pivot.spring_length = - spring_length
	vertical_pivot.global_transform.origin.y = spring_height
	
