extends MeshInstance

func _ready():
	$PosePoint2.connect("activated", self, "on_activated")
	$Control/DefaultsMenu/Layout/Mid/Preview/Viewport/Camera/Armature.play("Sit_Floor")
	
	
func on_activated(host):
	$Control.host = host
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Control.show()
