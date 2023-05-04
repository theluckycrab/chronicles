extends Node

static func execute(_who, scene):
	Events.emit_signal("scene_change_request", scene)
	print(scene)
