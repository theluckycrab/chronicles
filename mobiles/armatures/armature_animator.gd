tool
extends AnimationPlayer
class_name ArmatureAnimator

"""
	The ArmatureAnimator is for simplifying a root-motion workaround. Because AnimationTree is such
		a pain, we just use a single OneShot node and swap out the animation on it. The animator
		is responsible for starting/stopping/swapping between a normal AnimationPlayer when
		root-motion is not needed and the AnimationTree when it is needed. 
		
	Dependencies : AnimationTree
	Setup :
		AnimationTree needs :
			- a blend tree root
				- set resource > local to scene
			- a oneshot node with blends set to 0
				- set resource > local to scene
			- an animation node named "Action"
				- set resource > local to scene
			- set output > resource > local to scene
			- set the root motion bone
"""

signal keyframe
var override_list: Dictionary = {}
var last_animation: String = ""
onready var tree: AnimationTree

func _enter_tree():
	setup()

func _ready() -> void:
	var _discard = connect("animation_started", self, "on_animation_started")
	
func get_current_animation() -> String:
	if is_using_root_motion():
		return tree.get_tree_root().get_node("Action").animation
	else:
		return current_animation
		
func is_using_root_motion() -> bool:
	return tree.get("parameters/OneShot/active")
	
func keyframe() -> void:
	emit_signal("keyframe")

func get_root_motion() -> Transform:
	return tree.get_root_motion_transform()

func on_animation_started(anim:String) -> void:
	if anim in override_list:
		play(override_list[anim])

func play_animation(animation: String, motion: bool = false):
	if motion:
		stop()
		play_with_root_motion(animation)
	else:
		tree.active = false
		play(animation)
	last_animation = animation

func play_with_root_motion(anim:String) -> void:
	stop()
	var anim_node = tree.get_tree_root().get_node("Action")
	anim_node.animation = anim
	tree.active = false
	tree.active = true
	tree.set("parameters/OneShot/active", false)
	tree.set("parameters/OneShot/active", true)

func setup():
	root_node = get_path_to(get_parent().get_parent())
	playback_process_mode = AnimationPlayer.ANIMATION_PROCESS_PHYSICS
	tree = get_node("AnimationTree")
	tree.process_mode = AnimationTree.ANIMATION_PROCESS_PHYSICS
	tree.anim_player = get_path()
	tree.root_motion_track = "../../Skeleton:root"
