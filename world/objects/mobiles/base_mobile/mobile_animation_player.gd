extends AnimationPlayer

signal keyframe

var override_list = {
}

onready var tree = $AnimationTree


func _ready() -> void:
	var _discard = connect("animation_started", self, "on_animation_started")
	
	
func on_animation_started(anim:String) -> void:
	if anim in override_list:
		play(override_list[anim])
	

func keyframe() -> void:
	emit_signal("keyframe")


func play_with_root_motion(anim:String) -> void:
	stop()
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
