extends Node

var velocity = Vector3.ZERO
var gravity = 9

onready var host : KinematicBody = get_parent()


func add_force(force:Vector3) -> void:
	velocity += force
	
	
func apply_gravity() -> void:
	if host.is_on_floor():
		return
	add_force(Vector3.DOWN * gravity)


func commit_move() -> void:
	var commit_vel = velocity
	velocity = Vector3.ZERO
	if host.is_on_floor() and commit_vel.y == 0:
		host.move_and_slide_with_snap(commit_vel, Vector3.DOWN, Vector3.UP, true)
		return
	if commit_vel.y == 0:
		apply_gravity()
	host.move_and_slide(commit_vel, Vector3.UP, false)
	pass
