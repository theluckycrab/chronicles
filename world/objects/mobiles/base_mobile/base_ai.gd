extends Node

onready var host = get_parent()

func get_wasd():
	return Vector3.ZERO

func get_wasd_cam():
	return Vector3.BACK.rotated(Vector3.UP, host.armature.rotation.y)
