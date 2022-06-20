extends Area

var host = null

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if  host and host.net_stats.netID == Network.get_nid() and !host.in_combat and host != null:
			host.set_state("interact")
			get_parent().activate(host)
			host = null

func _ready():
	var _discard = connect("body_entered", self, "on_body_entered")
	var _dicksward = connect("body_exited", self, "on_body_exited")
	pass
	

func on_body_entered(body):
	if body is BaseMobile:
		print(get_parent().name, " is ready")
		host = body


func on_body_exited(_body):
	print(get_parent().name, " is inactive")
	host = null
