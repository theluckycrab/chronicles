tool
extends AnimationPlayer
class_name ArmatureAnimator

signal keyframe
var override_list: Dictionary = {}
var last_animation: String = ""
onready var tree: AnimationTree

func _enter_tree():
	setup()
	
func get_current_animation() -> String:
	if is_using_root_motion():
		return tree.get_tree_root().get_node("Action").animation
	else:
		return current_animation
		
func is_using_root_motion() -> bool:
	return tree.get("parameters/OneShot/active")
	
func keyframe(bone:String = "Mainhand") -> void:
	emit_signal("keyframe", bone)

func get_root_motion() -> Transform:
	return tree.get_root_motion_transform()

func play_animation(animation: String, motion: bool = false):
	if override_list.has(animation):
		animation = override_list[animation]
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

func add_animation_override(key, animation):
	override_list[key] = animation
	
func remove_animation_override(key):
	var _discard = override_list.erase(key)
