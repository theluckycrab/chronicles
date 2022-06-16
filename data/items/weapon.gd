class_name Weapon
extends Item

export(PoolStringArray) var combo
export(String) var strong
export(int) var damage

var state = Hitbox.states.GHOST

func strike():
	state = Hitbox.STRIKE
	
	
func ghost() -> void:
	state = Hitbox.GHOST


func get_combo():
	return combo
	
func get_damage():
	var damage_object = Damage.new()
	damage_object.damage = damage
	damage_object.tags = ["Player"]
	return damage_object
