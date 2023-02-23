extends Spatial

"""
	The SceneManager is responsible for controlling the current scene.
	
	Dependencies : res://scenes
	Setup : 
"""

export(String) var start_scene = "char_creation"

var current_scene = null

func _ready():
	switch_scene(start_scene)
	Events.connect("scene_change_request", self, "switch_scene")

func switch_scene(scene:String ) -> void:
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	current_scene = load("res://scenes/"+scene.to_lower()+".tscn")
	if is_instance_valid(current_scene):
		current_scene = current_scene.instance()
		add_child(current_scene)
	else:
		print("[SceneManager] tried to switch to a scene that does not exist.")
