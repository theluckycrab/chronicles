extends Node

var peer = NetworkedMultiplayerENet.new()

func _ready():
	peer.create_server(5555, 1)
	get_tree().network_peer = peer

func relay_signal(sig, args):
	rpc("emit", sig, args)

remotesync func emit(sig, args):
	Events.emit_signal(sig, args)
