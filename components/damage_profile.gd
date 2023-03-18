extends Node
class_name DamageProfile

var profile = {}

func _init(dp:Dictionary = {}):
	profile = dp.duplicate(true)

func add(type, value=0) -> void:
	if profile.has(type):
		profile[type] += value
	else:
		profile[type] = value
	if profile[type] < 0:
		profile.remove(type)
		print("Added negative ", type, " to damage profile ", self)
		
func remove(type, value=0) -> void:
	if profile.has(type):
		profile[type] -= value
	else:
		profile[type] = 0
	if profile[type] == 0:
		profile.erase(type)
		
func has(type) -> bool:
	return profile.has(type)

func as_dict() -> Dictionary:
	return profile
