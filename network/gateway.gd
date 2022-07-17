extends Node

var peer = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 5556
var ip = "127.0.0.1"
var user
var password
var cert = load("res://data/assets/X509_Certificate.crt")

func _process(_delta):
	if get_custom_multiplayer() == null:
		return
	if ! custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func join(ur, pw):
	peer = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	peer.set_dtls_enabled(true)
	peer.set_dtls_verify_enabled(false) #change this one if we ever get signed
	peer.set_dtls_certificate(cert)
	user = ur
	password = pw
	peer.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(peer)
	print("Gateway server ready")
	peer.connect("connection_succeeded", self, "on_connection_succeeded")
	peer.connect("connection_failed", self, "on_connection_failed")
	
func on_connection_succeeded():
	print("Successfully connected to a gateway")
	request_login()
	
func on_connection_failed():
	print("Unable to connect to gateway")
	
func request_login():
	print("requesting login from gateway")
	rpc_id(1, "request_login", user, password)
	user = ""
	password = ""

remote func receive_login_result(result, token):
	print("Login request result : ", result)
	if result == true:
		Network.token = token
		Network.join()
	peer.disconnect("connection_failed", self, "on_connection_failed")
	peer.disconnect("connection_succeeded", self, "on_connection_succeeded")
