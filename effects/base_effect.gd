extends Node
class_name BaseEffect

var current
var host

func _init(args):
	current = args
	pass
	
func proc():
	host.call(current.function, current.args)

func exit():
	host.call(current.exit_function, current.exit_args)

func _ready():
	proc()
	
func _physics_process(delta):
	if current.type == "buff":
		if Input.is_action_just_pressed("ui_right"):
			exit()
