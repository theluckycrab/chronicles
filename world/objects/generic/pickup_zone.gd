extends Area

var host = null

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if host and !host.in_combat:
			host.set_state("interact")
			get_parent().activate(host)
			get_tree().set_input_as_handled()

func _ready():
	var _discard = connect("body_entered", self, "on_body_entered")
	var _dicksward = connect("body_exited", self, "on_body_exited")
	pass
	

func on_body_entered(body):
	print(get_parent().name, " is ready")
	host = body


func on_body_exited(_body):
	print(get_parent().name, " is inactive")
	host = null
