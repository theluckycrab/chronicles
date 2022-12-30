extends Spatial

func add_effect(e):
	if e is String:
		e = BaseEffect.new(e)
	e.current.target = get_parent()
	if e.current.trigger != "none":
		for i in e.current.trigger:
			e.connect(i, get_parent(), e.current.effect) 
	add_child(e)
