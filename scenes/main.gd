extends Spatial

export(String) var start_scene = "char_creation"

func _ready():
	Events.emit_signal("scene_change_request", start_scene)
