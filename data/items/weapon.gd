class_name Weapon
extends Item

export(PoolStringArray) var combo
export(String) var strong

var state = Hitbox.states.GHOST

func strike():
	state = Hitbox.STRIKE
	
	
func ghost() -> void:
	state = Hitbox.GHOST


func get_combo():
	return combo
