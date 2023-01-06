extends State

var facing
var combo = ["Fist_Combo_1", "Fist_Combo_2", "Fist_Combo_3"]
var combo_counter = 0

func _init():
	priority = 2
	index = "Light_Attack"

func can_enter():
	return host.is_on_floor()
	
func can_exit():
	return host.get_animation() == ""

func enter():
	host.play(combo[combo_counter], true)
	facing = host.armature.rotation.y
	combo_counter += 1
	pass
	
func exit():
	if combo_counter > combo.size() -1:
		combo_counter = 0
	pass
	
func execute():
	pass
