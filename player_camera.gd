extends Spatial

var last_mouse_relative = Vector2.ZERO
var h_sens = 0.25
var v_sens = 0.25
var v_invert = -1
var h_invert = 1
var min_v_angle = deg2rad(-25)
var max_v_angle = deg2rad(25)
var views = []
var stored_delta = 0

onready var v = $Vertical
onready var camera = $Vertical/Camera

func _ready():
	build_views()
	change_view(0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
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
			
	if event.as_text() as int < views.size():
		var v = event.as_text() as int
		if v == 0:
			if event.as_text() != "0":
				return
		change_view(v)
		
func build_views():
	for i in get_children():
		if i is Position3D:
			views.append(i)
		
		
func change_view(v):
	print("Switching to Camera ", v)
	camera.global_transform = views[v].global_transform
	camera.rotation.y = deg2rad(-180)
	rotation.y = views[v].rotation.y

func apply_rotation():
	rotation.y = lerp_angle(rotation.y, rotation.y - deg2rad(last_mouse_relative.x), h_sens * h_invert)
	v.rotation.x = lerp_angle(v.rotation.x, v.rotation.x - deg2rad(last_mouse_relative.y), v_sens * v_invert)
	
func apply_limits():
	v.rotation.x = clamp(v.rotation.x, min_v_angle, max_v_angle)
