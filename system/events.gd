extends Node


#requests
signal scene_change_request
signal menu_opened
#completed
signal menu_closed
#function calls in disguise
signal console_print
signal effect_added
signal register
signal spawn
signal network_command


func _ready() -> void:
	print("Events ready")
