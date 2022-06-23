extends Area

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	
func on_body_entered(body):
	if body is BaseMobile:
		body.viewers += 1
		
func on_body_exited(body):
	if body is BaseMobile:
		body.viewers -= 1
