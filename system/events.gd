extends Node


#requests
signal scene_change_request
signal menu_opened
signal player_died
#completed
signal menu_closed
signal save_data_loaded
#function calls in disguise
signal console_print
signal net_print
signal effect_added
signal register
signal unregister
signal spawn
signal network_command
signal reload_game_request


func _ready() -> void:
	print("Events ready")
