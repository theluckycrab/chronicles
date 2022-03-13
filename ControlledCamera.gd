extends Spatial

onready var H = get_parent().get_parent()
onready var V = get_parent()

var rightStickVector = Vector2.ZERO
var mouseMotionVector = Vector2.ZERO
var rightStickDeadZone = 0.25
var hSpeed = 1.25
var vSpeed = 1.25
var vLookLimitDegrees = 35

func _input(event):
	if event is InputEventMouseMotion:
		mouseMotionVector = event.relative
	else:
		rightStickVector.x = Input.get_joy_axis(1, JOY_AXIS_2)
		rightStickVector.y = Input.get_joy_axis(1, JOY_AXIS_3)

func _physics_process(_delta):
	Calc_Rotation()
	Apply_Rotation()
	
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
	print(y)
	if y > vLookLimitDegrees * .25 and sign(rightStickVector.y) == -1:
		rightStickVector.y = 0
	elif y < -vLookLimitDegrees and sign(rightStickVector.y) == 1:
		rightStickVector.y = 0
		
func Apply_Rotation():
	var angles = Vector2(H.rotation_degrees.y, V.rotation_degrees.x)
	var movement = rightStickVector
	angles.x = lerp_angle(angles.x, angles.x + movement.x, -hSpeed)
	angles.y = lerp_angle(angles.y, angles.y + movement.y, -vSpeed)
	angles.x = deg2rad(angles.x)
	angles.y = deg2rad(angles.y)
	H.rotation.y = angles.x
	V.rotation.x = angles.y
	
func Get_H_Rotation():
	return H.rotation.y
	
func Get_V_Rotation():
	return V.rotation.x
	
func Get_Rotation():
	return Vector2(H.rotation.y, V.rotation.x)
