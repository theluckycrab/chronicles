extends TextEdit

var history = ""
var current_line = ""
signal text_entered

func _ready():
	connect("text_changed", self, "on_text_changed")
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		history = text
		emit_signal("text_entered", history, current_line)
	
func on_text_changed():
	if text != text.trim_prefix(history):
		current_line = text.trim_prefix(history)
	text = history + current_line
	cursor_set_line(100)
	cursor_set_column(100)
	
	
func post(t):
	current_line = ""
	history += t
	text = history
	on_text_changed()
