extends Node

"""
	The events singleton is used for passing very wide-reaching signals. If various parts of the
		application need to respond to player death, Events can emit a "player_died" signal without
		each of those parts needing a direct reference to the currently-existing player. They'll
		only need to know about the Events singleton, which can always be expected to be there.
		
		Truly decoupled objects should not use this singleton.
"""

signal chat_message_received
signal ui_opened
signal ui_closed
signal char_data_changed
signal scene_change_request
