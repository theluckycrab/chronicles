extends Node


#requests
signal scene_change_request

#completed


#function calls in disguise
signal console_print
signal spawn_request
signal item_added
signal item_equipped
signal effect_added
signal register
signal spawn
signal network_command


func _ready():
	print("Events ready")
