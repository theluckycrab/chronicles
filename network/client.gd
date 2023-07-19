extends Node

"""
	Client is for managing the client's connection to the server and handling incoming network requests.
"""

var port := 5555
onready var ip := IP.resolve_hostname("alpha.crabsoft.download")
var peer := NetworkedMultiplayerENet.new()
var nid := 1

func join() -> void:
	var _discard = peer.connect("connection_succeeded", self, "on_connection_succeeded")
	var _dicsard = peer.create_client(ip, port)
	get_tree().network_peer = peer

remote func npc(args: Dictionary) -> void:
	Simulation.parse_npc(args)

func on_connection_succeeded() -> void:
	nid = get_tree().get_network_unique_id()
	Server.send_chat("[System] " + Data.get_char_value("name") + " has joined the server.")
	print("You have joined ", ip, " as ", nid)

remote func receive_map_history(history: Dictionary) -> void:
	if history.client_version != Data.get_client_version():
		OS.alert("Version Mismatch\n"\
			+"\nYour Version: "+Data.get_client_version()\
			+"\nServer Version: " + history.client_version + "\nhttps://website.crabsoft.download/chronicles.zip", "Chronicles of Delonda")
		get_tree().quit(0)
		return
	for command in history[Simulation.get_map_name()]:
		npc(command)

	var p = load("res://mobiles/mobile.tscn").instance()
	add_child(p)
	p.name = str(nid)
	p.build_from_dictionary(Data.get_mobile_data("player"))
	Simulation.spawn(p, Vector3(0,15,-45))
	p.queue_free()

remote func receive_chat(args):
	Events.emit_signal("chat_message_received", args)
