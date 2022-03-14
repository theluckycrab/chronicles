extends KinematicBody

var velocity = {
				controlled = Vector3.ZERO,
				force = Vector3.ZERO
				}
				
var gravity = {
				active = true,
				base = -1
				}
				
func _ready():
	Grab_Camera()

func _physics_process(_delta):
	Get_Controlled_Velocity()
	Move()
	
func Get_Controlled_Velocity():
	var lStickDeadZone = 0.25
	var speedMod = 5
	var x = Input.get_joy_axis(1, JOY_AXIS_0)
	var y = Input.get_joy_axis(1, JOY_AXIS_1)
	
	if abs(x) < lStickDeadZone and abs(y) < lStickDeadZone:
		velocity.controlled = Vector3.ZERO
		return
	velocity.controlled = Vector3(x, 0, y).normalized() * speedMod

func Move():
	Cam_Rotate_Controlled_Velocity()
	Apply_Gravity()
	Apply_Movement()
	Face_Controlled_Velocity()
	
func Cam_Rotate_Controlled_Velocity():
	var cam = get_viewport().get_camera()
	var camRot = Vector3.ZERO
	if cam.has_method("Get_H_Rotation"):
		camRot = cam.Get_H_Rotation()
	else:
		camRot = cam.rotation.y
	velocity.controlled = velocity.controlled.rotated(Vector3.UP, camRot)
		
func Apply_Movement():
	var discard = move_and_slide_with_snap(velocity.controlled + velocity.force, Vector3.DOWN, Vector3.UP, true)

func Apply_Gravity():
	if gravity.active and !is_on_floor():
		velocity.force += Vector3(0,gravity.base, 0)

func Face_Controlled_Velocity():
	if velocity.controlled == Vector3.ZERO:
		return
	var angle = atan2(velocity.controlled.x, velocity.controlled.z)
	Body_Face(angle)
	
func Body_Face(targetAngle, turnSpeed:float=0.2):
	$MeshInstance.rotation.y = lerp_angle($MeshInstance.rotation.y, targetAngle, turnSpeed)
	
func Grab_Camera():
	var cam = get_viewport().get_camera()
	if cam.has_method("Set_Track_Target"):
		cam.Set_Track_Target(self)
