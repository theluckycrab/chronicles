extends Spatial

onready var H = get_parent().get_parent()
onready var V = get_parent()

var transformTarget = null

var rightStickVector = Vector2.ZERO
var mouseMotionVector = Vector2.ZERO
var rightStickDeadZone = 0.25
var hSpeed = 2.75
var vSpeed = 2.75
var vLookLimitDegrees = 35
var trackSpeed = 0.1

func _input(event):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		mouseMotionVector = event.relative
	else:
		mouseMotionVector = Vector2.ZERO
		rightStickVector.x = Input.get_joy_axis(1, JOY_AXIS_2)
		rightStickVector.y = Input.get_joy_axis(1, JOY_AXIS_3)
	Apply_Rotation(mouseMotionVector, Vector2(0.6, 0.6))

func _process(_delta):
	Track_Target()
	Calc_Rotation()
	if rightStickVector != Vector2.ZERO:
		Apply_Rotation(rightStickVector, Vector2(hSpeed, vSpeed))
	
func Calc_Rotation():
	Apply_RightStick_DeadZone()
	Apply_Look_Limit()
	
func Apply_RightStick_DeadZone():
	if abs(rightStickVector.x) < rightStickDeadZone:
		rightStickVector.x = 0
	if abs(rightStickVector.y) < rightStickDeadZone:
		rightStickVector.y = 0
		
func Apply_Look_Limit():
	var y = rad2deg(V.rotation.x) + rightStickVector.y
	if y > vLookLimitDegrees * .25 and sign(rightStickVector.y) == -1:
		rightStickVector.y = 0
	elif y < -vLookLimitDegrees and sign(rightStickVector.y) == 1:
		rightStickVector.y = 0
		
func Apply_Rotation(directionVector:Vector2, speedVector:Vector2):
	var angles = Vector2(H.rotation_degrees.y, V.rotation_degrees.x)
	var movement = directionVector
	angles.x = deg2rad(angles.x)
	angles.y = deg2rad(angles.y)
	movement.x = deg2rad(movement.x)
	movement.y = deg2rad(movement.y)
	angles.x = lerp_angle(angles.x, angles.x + movement.x, -speedVector.x)
	angles.y = lerp_angle(angles.y, angles.y + movement.y, -speedVector.y)
	H.rotation.y = angles.x
	V.rotation.x = angles.y
	
func Get_H_Rotation():
	return H.rotation.y
	
func Get_V_Rotation():
	return V.rotation.x
	
func Get_Rotation():
	return Vector2(H.rotation.y, V.rotation.x)

func Track_Target():
	if !transformTarget:
		return
	var position:Vector3 = H.global_transform.origin
	var newPosition = transformTarget.global_transform.origin
	H.global_transform.origin = position.linear_interpolate(newPosition, trackSpeed)
	
func Set_Track_Target(who):
	transformTarget = who
