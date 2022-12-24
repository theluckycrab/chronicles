extends State

func _init():
	priority = 0

func can_enter():
	return true
	
func can_exit():
	return true

func enter():
	pass
	
func exit():
	pass
	
func execute(_host):
	print("fly")
	pass
