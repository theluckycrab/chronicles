extends Node

signal login_failed

var peer = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 5556
var ip = "127.0.0.1"
var username: String = ""
var password: String = ""
var create_account: bool = false
var cert = load("res://assets/X509_Certificate.crt")

func _process(_delta):
	if get_custom_multiplayer() == null:
		return
	if ! custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func join(un, pw, c = false):
	peer = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	peer.set_dtls_enabled(true)
	peer.set_dtls_verify_enabled(false) #change this one if we ever get signed
	peer.set_dtls_certificate(cert)
	username = un
	password = pw.sha256_text()
	create_account = c
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
	print("Requesting login from gateway")
	rpc_id(1, "request_login", username, password, create_account)
	username = ""
	password = ""
	create_account = false

remote func receive_login_result(result, token):
	match result:
		0: #success!
			print("Credentials verified!")
			GameServer.token = token
			GameServer.join()
		1: #username not found
			print("Permission denied.")
			emit_signal("login_failed", "account")
		2: #bad password
			print("Permission denied.")
			emit_signal("login_failed", "password")
	peer.disconnect("connection_failed", self, "on_connection_failed")
	peer.disconnect("connection_succeeded", self, "on_connection_succeeded")
