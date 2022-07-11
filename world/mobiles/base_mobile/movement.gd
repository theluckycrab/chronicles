extends Node

var velocity: Vector3 = Vector3.ZERO
var gravity: float = 9

onready var host : KinematicBody = get_parent()


func add_force(force:Vector3) -> void:
	velocity += force
	
	
func apply_gravity() -> void:
	if host.is_on_floor():
		return
	add_force(Vector3.DOWN * gravity)


func commit_move() -> void:
	var commit_vel = velocity
	if host.armature.anim.tree.active:
		commit_vel += (get_root_motion().origin / host.stored_delta).rotated(Vector3.UP, host.armature.rotation.y)
	velocity = Vector3.ZERO
	if host.is_on_floor() and commit_vel.y == 0:
		var _discard = host.move_and_slide_with_snap(commit_vel, Vector3.DOWN, Vector3.UP, true)
		return
	#if commit_vel.y == 0:
	apply_gravity()
	var _discard = host.move_and_slide(commit_vel, Vector3.UP, false)


func get_root_motion():
	return host.get_root_motion()
