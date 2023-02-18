extends Node

const colors = [
		"aqua",
		"black",
		"blue",
		"fuchsia",
		"gray",
		"green",
		"lime",
		"maroon",
		"navy",
		"purple",
		"red",
		"teal",
		"white",
		"yellow"]

static func execute(_who, _anim):
	var message = "Valid colors include : " + str(colors)
	Events.emit_signal("chat_message_received", {"text":message})
