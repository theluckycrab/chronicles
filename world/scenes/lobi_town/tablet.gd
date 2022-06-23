extends MeshInstance

onready var pose_point = $PosePoint2

func _ready():
	pose_point.connect("activated", self, "on_activated")
	$Control/DefaultsMenu/Layout/Mid/Preview/Viewport/Camera/Armature.play("Sit_Floor")
	
	
func on_activated(host):
	$Control.host = host
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Control.show()
