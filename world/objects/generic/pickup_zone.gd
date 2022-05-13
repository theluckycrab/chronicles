extends Area

var host = null

func _input(event):
	if event.as_text() == "Enter":
		if ! event.is_echo():
			if event.is_pressed():
				if host:
					get_parent().activate(host)
					get_tree().set_input_as_handled()
					print("dongers")

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
