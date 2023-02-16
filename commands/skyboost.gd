extends Node

static func execute(who, height):
	who.add_force(Vector3.UP * int(height))
