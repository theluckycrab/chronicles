extends Spatial

var rotation_speed = 15
onready var anim = $AnimationPlayer

func face_dir(wasd, delta):
	var a = atan2(wasd.x, wasd.z)
	rotation.y = lerp_angle(rotation.y, a, rotation_speed * delta)

func play(animation, motion: bool = false):
	if motion:
		anim.stop()
		anim.play_with_root_motion(animation)
	else:
		anim.tree.active = false
		anim.play(animation)
	anim.last_animation = animation
