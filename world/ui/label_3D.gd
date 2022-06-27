extends Spatial
class_name Label3D

export(String) onready var text setget set_label_text, get_label_text
var lifespan = 1
var rolling = false
export(Color) var color setget set_label_color

func _ready():
	$Timer.connect("timeout", self, "on_timer")
	if rolling:
		$Timer.start(lifespan)
	#yield(get_tree().create_timer(lifespan), "timeout")
	#queue_free()

func _physics_process(delta):
	if $Label.text != "":
		position()

func on_timer():
	$Label.text = ""
	$Label.rect_size = Vector2.ZERO


func set_label_text(t):
	$Label.text = t
	if lifespan > 0:
		$Timer.start(lifespan)
	
func get_label_text():
	return $Label.text

func set_label_color(c):
	$Label.modulate = c

func position():
	var cam = get_viewport().get_camera()
	var pos = cam.unproject_position(global_transform.origin)
	#pos.x -= $Label.rect_position.x / 2
	var win = OS.get_window_size()
	if $VisibilityNotifier.is_on_screen():
		pos.x -= 100
		$Label.rect_position = pos
		#print("normal")
	else:
		var mpos = global_transform.origin
		var center = win / 2
		var t = cam.global_transform.origin.direction_to(mpos).normalized() * 10
		var s = cam.project_position(center + Vector2(0,200), 20)
		s = s + t
		var nector = cam.unproject_position(s) 
		$Label.rect_position = nector
