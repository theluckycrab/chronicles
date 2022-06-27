extends PhaseMesh

func activate(_host):
	$LevelSelectMenu.show()

onready var pose_label = $PosePoint/InteractableZone/ActionLabel

func _ready():
	pose_label.text = ""
