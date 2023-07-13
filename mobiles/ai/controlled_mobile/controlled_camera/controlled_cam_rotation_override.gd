extends Camera

export(NodePath) onready var parent = get_node_or_null(parent)

func _get(property):
	match property:
		"rotation":
			return parent.rotation

func set_lock_target(t):
	parent.set_lock_target(t)
