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

static func execute(_who, color):
	if color in colors:
		Data.set_char_value("chat_color", color)
