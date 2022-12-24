extends Spatial

var rotation_speed = 15

func face_dir(wasd, delta):
	var a = atan2(wasd.x, wasd.z)
	rotation.y = lerp_angle(rotation.y, a, rotation_speed * delta)
