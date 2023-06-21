extends Spatial

export(String) var start_scene = "char_creation"

func _ready():
	Simulation.switch_scene(start_scene)
