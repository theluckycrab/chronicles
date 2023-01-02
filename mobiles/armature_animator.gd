extends AnimationPlayer

signal keyframe

var override_list = {}

var last_animation = ""
var host = null

onready var tree = $AnimationTree

func _ready() -> void:
	#set_host()
	var _discard = connect("animation_started", self, "on_animation_started")
	
	
func on_animation_started(anim:String) -> void:
	if anim in override_list:
		play(override_list[anim])
	

func keyframe() -> void:
	emit_signal("keyframe")


func play_with_root_motion(anim:String) -> void:
	stop()
	get_parent().get_parent().using_gravity = false
	var anim_node = tree.get_tree_root().get_node("Action")
	anim_node.animation = anim
	tree.active = false
	tree.active = true
	tree.set("parameters/OneShot/active", false)
	tree.set("parameters/OneShot/active", true)
	
	
	
func get_root_motion() -> Transform:
	return tree.get_root_motion_transform()


func is_using_root_motion() -> bool:
	return tree.get("parameters/OneShot/active")


func set_host():
	root_node = get_parent().get_parent().get_path()
	host = get_node(root_node)

func get_current_animation():
	if is_using_root_motion():
		return tree.get_tree_root().get_node("Action").animation
	else:
		return current_animation
