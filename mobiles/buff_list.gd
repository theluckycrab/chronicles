extends Timer

onready var host = get_parent()

func tick(delta):
	for buff in get_children():
		if buff is BaseBuff:
			if buff.can_exit():
				buff.exit()
				continue
			else:
				buff.update(delta)
	display()

func add_buff(b):
	b.set_host(host)
	add_child(b)
	
func remove_buff(index: String, all_instances:bool = false):
	for buff in get_children():
		if buff is BaseBuff and buff.get_index() == index:
			buff.exit()
			if !all_instances:
				return

func get_buffs():
	var return_list = []
	for buff in get_children():
		if buff is BaseBuff:
			return_list.append(buff)
	return return_list
	
func display():
	if !host.is_dummy():
		var t = ""
		for i in get_children():
			if i is BaseBuff:
				t += "\n " + i.current.name
		$Display.text = t
