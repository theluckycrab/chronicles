extends Control

"""
	The chatbox is made up of an entry and a history. It sends and receives printable messages from
		the Events singleton. History is currently a RichTextLabel to allow for fancy colored text. 
		However, this opens up the program to several potential user-side issues, such as trying to
		load images that aren't in the res:// path. Currently, we get more than we lose.
		
	Usage : Entering a message into the chat will send a request to Server.send_chat(words). The 
		chat history hooks up to the Events signal "chat_message_received". You should emit that 
		signal to print things to the chatbox.
		
	Dependencies : Server, Events, Data
"""

onready var history: RichTextLabel = $VBoxContainer/History
onready var entry: LineEdit = $VBoxContainer/Entry

var entry_history = []
var entry_history_iterator = 0

func _ready():
	var _discard = entry.connect("text_entered", self, "on_entry")
	var _d = entry.connect("focus_entered", Events, "emit_signal", ["ui_opened"])
	var _di = entry.connect("focus_exited", Events, "emit_signal", ["ui_closed"])
	var _do = Events.connect("char_data_changed", self, "on_char_data_changed")
	entry.add_color_override("font_color", Color(Data.get_char_value("chat_color")))
	
func _input(event):
	if entry.has_focus():
		if event.is_action_pressed("ui_up"):
			traverse_history(1)
			accept_event()
		elif event.is_action_pressed("ui_down"):
			traverse_history(-1)
			accept_event()
		elif event.is_action_pressed("`"):
			abort_entry()
		elif event.is_action_pressed("ui_cancel"):
			abort_entry()
	elif event.is_action_pressed("`"):
		entry.grab_focus()
		entry.clear()
		accept_event()
	
func on_message_received(args: Dictionary) -> void:
	if args.has("message"):
		history.add_entry(args.message)

func on_entry(words: String) -> void:
	add_to_entry_history(words)
	if words.begins_with("/"):
		parse_command(words)
		return
	var chat_color = Data.get_char_value("chat_color")
	var chat_name = Data.get_char_value("name")
	words = "[color=#"+chat_color+"]["+chat_name+"]: "+words+"[/color]"
	Server.send_chat(words)
	
func add_to_entry_history(words: String) -> void:
	entry_history_iterator = 0
	entry_history.append(words)
	if entry_history.size() > 10:
		entry_history.remove(0)
	entry.clear()
	drop_focus()

func traverse_history(count: int) -> void:
	entry_history_iterator += count
	if entry_history_iterator <= 0 or entry_history.empty():
		entry_history_iterator = 0
		entry.text = ""
		return
	if entry_history_iterator > entry_history.size():
		entry_history_iterator = entry_history.size()
	entry.text = entry_history[entry_history.size() - entry_history_iterator]
	entry.caret_position = entry.text.length() #because we're using ui_up specifically
	entry.accept_event() #we must consume the input event to avoid lineedits normal behavior
	
func drop_focus() -> void:
	history.grab_click_focus()
	history.grab_focus()

func abort_entry() -> void:
	accept_event()
	drop_focus()
	entry.clear()

func parse_command(s: String) -> void:
	s = s.lstrip("/")
	var args = s.split(" ", false, 1)
	var host = get_node("/root/Main/"+Server.map+"/"+str(Client.nid))
	if is_instance_valid(host):
		if args.size() < 2:
			args.append("")
		if ResourceLoader.exists("res://commands/"+args[0]+".gd"):
			load("res://commands/"+args[0]+".gd").execute(host, args[1])
	entry.clear()
	drop_focus()
	
func on_char_data_changed() -> void:
	entry.add_color_override("font_color", Color(Data.get_char_value("chat_color")))
