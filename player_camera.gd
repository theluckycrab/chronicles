extends Spatial

var last_mouse_relative = Vector2.ZERO
var h_sens = 0.25
var views = []
var stored_delta = 0

func _ready():
	build_views()
	change_view(0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		last_mouse_relative = event.relative
		rotation.y = lerp_angle(rotation.y, rotation.y - deg2rad(last_mouse_relative.x), h_sens)
	if event.is_action_released("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.as_text() as int < views.size():
		var v = event.as_text() as int
		if v == 0:
			if event.as_text() != "0":
				return
		change_view(v)
		
func _process(delta):
	stored_delta = delta
		
func build_views():
	for i in get_children():
		if i is Position3D:
			views.append(i)
		
		
func change_view(v):
	print("Switching to Camera ", v)
	$Camera.global_transform = views[v].global_transform
	$Camera.rotation.y = deg2rad(-180)
	rotation.y = views[v].rotation.y
