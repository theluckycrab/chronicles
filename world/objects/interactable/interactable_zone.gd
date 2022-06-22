extends Area

export(String) var action = "Interact"


var host = null

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if  host and host.net_stats.netID == Network.get_nid() and !host.in_combat and host != null:
			host.set_state("interact")
			get_parent().call_deferred("activate", host)
			$ActionLabel.hide()
			host = null

func _ready():
	var _discard = connect("body_entered", self, "on_body_entered")
	var _dicksward = connect("body_exited", self, "on_body_exited")
	$ActionLabel.text = $ActionLabel.text + " " + action
	pass
	

func on_body_entered(body):
	if body is BaseMobile and body.net_stats.netID == Network.get_nid():
		host = body
		$ActionLabel.show()


func on_body_exited(body):
	if body is BaseMobile and body.net_stats.netID == Network.get_nid():
		host = null
		$ActionLabel.hide()
	

func set_action_label(text):
	action = text
	$ActionLabel.text = "E: " + text.capitalize()
	
