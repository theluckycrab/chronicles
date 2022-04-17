extends KinematicBody

var run_test = PlayerStateRun.new()

var velocity = {
				controlled = Vector3.ZERO,
				force = Vector3.ZERO
				}
				
var gravity = {
				active = true,
				base = -9
				}

var stored_delta = 0
				
				
func _ready():
	Grab_Camera()

func _physics_process(delta):
	stored_delta = delta
	if Input.is_action_just_pressed("sprint"):
		if $StateMachine.stateDict["Walk"] == run_test:
			reset_state("Walk")
		else:
			swap_state("Walk", run_test)
	#Get_Controlled_Velocity()
	Get_Controlled_Velocity_WASD()
	$StateMachine.Execute()
	Move()
	
func Get_Controlled_Velocity_WASD():
	var x = Input.get_action_strength("d") - Input.get_action_strength("a")
	var y = Input.get_action_strength("s") - Input.get_action_strength("w")
	var speedMult = 5
	velocity.controlled = Vector3(x, 0, y).normalized() * speedMult
	
func Get_Controlled_Velocity():
	var lStickDeadZone = 0.25
	var speedMult = 5
	var x = Input.get_joy_axis(1, JOY_AXIS_0)
	var y = Input.get_joy_axis(1, JOY_AXIS_1)
	
	if abs(x) < lStickDeadZone and abs(y) < lStickDeadZone:
		velocity.controlled = Vector3.ZERO
		return
		
	velocity.controlled = Vector3(x, 0, y).normalized() * speedMult

func Move():
	Cam_Rotate_Controlled_Velocity()
	Apply_Gravity()
	Apply_Movement()
	Face_Controlled_Velocity()
	Reset_Velocity()
	
func Cam_Rotate_Controlled_Velocity():
	var cam = get_viewport().get_camera()
	var camRot = Vector3.ZERO
	if cam.has_method("Get_H_Rotation"):
		camRot = cam.Get_H_Rotation()
	else:
		camRot = cam.rotation.y
	velocity.controlled = velocity.controlled.rotated(Vector3.UP, camRot)
		
func Apply_Movement():
	if velocity.force.y <= 0:
		var _discard = move_and_slide_with_snap(velocity.controlled + velocity.force, Vector3.DOWN, Vector3.UP, true)
	else:
		var _discard = move_and_slide(velocity.controlled + velocity.force, Vector3.UP, false)

func Apply_Gravity():
	if gravity.active and !is_on_floor():
		velocity.force += Vector3(0,gravity.base, 0)

func Face_Controlled_Velocity():
	if velocity.controlled == Vector3.ZERO:
		return
	var angle = atan2(velocity.controlled.x, velocity.controlled.z)
	Body_Face(angle)
	
func Body_Face(targetAngle, turnSpeed:float=0.2):
	$Armature.rotation.y = lerp_angle($Armature.rotation.y, targetAngle, turnSpeed)
	
func Grab_Camera():
	var cam = get_viewport().get_camera()
	if cam.has_method("Set_Track_Target"):
		cam.Set_Track_Target(self)
		
func Add_Force(addedForceVector:Vector3):
	velocity.force += addedForceVector
	
func Set_Controlled_Velocity(vel:Vector3):
	velocity.controlled = vel

func Reset_Velocity():
	velocity.controlled = Vector3.ZERO
	velocity.force = Vector3.ZERO
	
func Animate(anim):
	$Armature/AnimationPlayer.play(anim)
	
func swap_state(slot:String, state_object:Node):
	$StateMachine.swap_state(slot, state_object)
	
func reset_state(slot:String):
	$StateMachine.reset_state(slot)
