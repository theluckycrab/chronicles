extends RichTextLabel

func _ready():
	var _discard = Events.connect("chat_message_received", self, "on_chat_message_received")
	Events.emit_signal("chat_message_received", "[System] You begin to feel test message.")
	
func get_formatted_string(e: String) -> String:
	if e.begins_with("[System]"):
		e = "[color=silver]" + e + "[/color]"
	return e

func add_entry(words: String) -> void:
	bbcode_text += get_formatted_string(words + "\n")

func on_chat_message_received(message) -> void:
	var text = ""
	if message is Dictionary:
		if message.has("text"):
			text = message.text
	if message is String:
		text = message
	add_entry(text)
