extends Area

export(String) var action = "Interact"

signal entered
signal exited
var host = null

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if  host != null and host.net_stats.netID == Network.get_nid() and !host.in_combat and host.can_act:
			host.set_state("interact")
			get_parent().call_deferred("activate", host)
			$ActionLabel.hide()
			#$Label3D.visible = false
			#host = null

func _ready():
	var _discard = connect("body_entered", self, "on_body_entered")
	var _dicksward = connect("body_exited", self, "on_body_exited")
	$ActionLabel.text = $ActionLabel.text + " " + action
	pass
	

func on_body_entered(body):
	if body is BaseMobile and body.net_stats.netID == Network.get_nid():
		host = body
		emit_signal("entered", host)
		$ActionLabel.show()
		#$Label3D.visible = true


func on_body_exited(body):
	if body is BaseMobile and body.net_stats.netID == Network.get_nid():
		emit_signal("exited", host)
		host = null
		$ActionLabel.hide()
		#$Label3D.visible = false
	

func set_action_label(text):
	action = text
	$ActionLabel.text = "E: " + text.capitalize()
	#$Label3D.text = "E: " + text.capitalize()
