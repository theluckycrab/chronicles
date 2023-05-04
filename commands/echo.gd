extends Node

static func execute(_who, message):
	Events.emit_signal("chat_message_received", "[Log] " + message)
	print(message)
