extends Node
class_name DamageProfile

var profile = {}
var source_nid = 0

func _init(dp:Dictionary = {}, source:int = 0):
	profile = dp.duplicate(true)
	set_source(source)

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

func set_source(nid: int) -> void:
	source_nid = nid
	add("source", nid)
		
func get_source() -> int:
	return source_nid
