extends Area

func _ready():
	var _dick = connect("body_entered", self, "on_body_entered")
	var _ard = connect("body_exited", self, "on_body_exited")
	
func on_body_entered(body):
	if body is BaseMobile:
		body.viewers += 1
		
func on_body_exited(body):
	if body is BaseMobile:
		body.viewers -= 1
