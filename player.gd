extends KinematicBody

var base_speed = 15
var move_speed = base_speed
var sprint_speed = base_speed * 4
var sprint_acceleration = base_speed
var turn_speed = 5
var turn_angle_limit = 30
var rotation_speed = 15#0.4

func get_wasd():
	var wasd = Vector3.ZERO
	wasd.x = Input.get_action_strength("a") - Input.get_action_strength("d")
	wasd.z = Input.get_action_strength("w") - Input.get_action_strength("s")
	return wasd
	
func _physics_process(delta):
	move(delta)

func body_turn(wasd, delta):
	var a = atan2(wasd.x, wasd.z)
	var c = 0
	$Armature.rotation.y = lerp_angle($Armature.rotation.y, a, rotation_speed * delta)
	print(abs(int(rad2deg($Armature.rotation.y)) % 360 - int(rad2deg(a))))
	var diff = abs(int(rad2deg($Armature.rotation.y)) % 360 - int(rad2deg(a)))
	if  diff < turn_angle_limit or diff > (360 - turn_angle_limit):
		return true
	return false
	
func move(delta):
	var wasd = get_wasd().normalized()
	move_speed = base_speed
	if wasd != Vector3.ZERO:
		if !body_turn(wasd.rotated(Vector3.UP, $CameraPivot.rotation.y), delta):
			sprint_acceleration = base_speed
		else:
			if Input.is_action_just_pressed("sprint"):
				sprint_acceleration = base_speed * 2
			if Input.is_action_pressed("sprint"):
				sprint_acceleration += base_speed * 1.33 * delta
				if sprint_acceleration > sprint_speed:
					sprint_acceleration = sprint_speed
				move_speed = sprint_acceleration
			else:
				sprint_acceleration = base_speed
				print("sprint")
	wasd = wasd.rotated(Vector3.UP, $CameraPivot.rotation.y)
	wasd.y = -1
	if wasd.z != 0:
		$Armature/AnimationPlayer.play("Walk")
	else:
		$Armature/AnimationPlayer.play("Idle")
	if move_speed == sprint_speed:
		$Armature/AnimationPlayer.play("Walk", 0, 3)
	move_and_slide(wasd * move_speed)
