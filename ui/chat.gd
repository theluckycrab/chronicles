extends Control

"""
	The chatbox is made up of an entry and a history. It sends and receives printable messages from
		the Events singleton. History is currently a RichTextLabel to allow for fancy colored text. 
		However, this opens up the program to several potential user-side issues, such as trying to
		load images that aren't in the res:// path. Currently, we get more than we lose.
		
	Usage : Chat will respond to "say" and "log" events. If you wish to print something to the chat, 
		you should use Events.emit_signal("chat_message", {args}). 
"""

onready var history: RichTextLabel = $VBoxContainer/History
onready var entry: LineEdit = $VBoxContainer/Entry

var entry_history = []
var entry_history_iterator = 0

func _ready():
	Events.connect("chat_message_received", self, "on_message_received")
	entry.connect("text_entered", self, "on_entry")
	
func _input(event):
	if event.is_action_pressed("ui_up"):
		traverse_history(1)
		accept_event()
	elif event.is_action_pressed("ui_down"):
		traverse_history(-1)
		accept_event()
	
func on_message_received(args: Dictionary) -> void:
	if args.has("message"):
		history.add_entry(args.message)

func on_entry(words: String) -> void:
	Events.emit_signal("chat_message_received", {"message":words})
	entry_history.append(words)
	if entry_history.size() > 10:
		entry_history.remove(0)
	entry.clear()

func traverse_history(count: int) -> void:
	entry_history_iterator += count
	if entry_history_iterator <= 0 or entry_history.empty():
		entry_history_iterator = 0
		entry.text = ""
		return
	if entry_history_iterator > entry_history.size():
		entry_history_iterator = entry_history.size()
	entry.text = entry_history[entry_history_iterator -1]
	entry.caret_position = entry.text.length() #because we're using ui_up specifically
	entry.accept_event() #we must consume the input event to avoid lineedits normal behavior
