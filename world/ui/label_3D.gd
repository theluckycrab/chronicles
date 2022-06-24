extends Spatial
class_name Label3D

export(String) onready var text setget set_label_text, get_label_text
export(int) var lifespan = 3
var rolling = false
export(Color) var color setget set_label_color

func _ready():
	$Timer.connect("timeout", self, "on_timer")
	if rolling:
		$Timer.start(lifespan)
	#yield(get_tree().create_timer(lifespan), "timeout")
	#queue_free()

func on_timer():
	$Viewport/Label.text = ""


func set_label_text(text):
	$Viewport/Label.text = text
	if lifespan > 0:
		$Timer.start(lifespan)
	
func get_label_text():
	return $Viewport/Label.text

func set_label_color(c):
	$Viewport/Label.modulate = c
