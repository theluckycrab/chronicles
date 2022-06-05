class_name Weapon
extends Item

export var attack = "fading_horizon" setget , get_attack
var state = Hitbox.states.GHOST


func get_attack():
	if attack is String:
		return Data.get_attack(attack)
	else:
		return attack


func strike():
	state = Hitbox.STRIKE
	
	
func ghost() -> void:
	state = Hitbox.GHOST
