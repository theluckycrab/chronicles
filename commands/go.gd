extends Node

static func execute(_who, anim):
	Events.emit_signal("scene_change_request", anim)
	print(anim)
