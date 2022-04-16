extends AnimationTree

export(NodePath) onready var host = get_node(host)


func Play(anim):
	tree_root.get_node("Animation").set_animation(anim)
	
