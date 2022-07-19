extends TextEdit

signal text_entered

var history: String = ""
var current_line: String = ""

func _ready():
	var _discard = connect("text_changed", self, "on_text_changed")
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		history = text
		emit_signal("text_entered", history, current_line)
	
func on_text_changed() -> void:
	if text != text.trim_prefix(history):
		current_line = text.trim_prefix(history)
	text = history + current_line
	cursor_set_line(100)
	cursor_set_column(1000)
	
func post(t:String) -> void:
	current_line = ""
	history += t
	text = history
	on_text_changed()
