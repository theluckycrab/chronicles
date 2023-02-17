extends Node
class_name BaseItem

"""
	These items are specific to the Delonda structure, where each item comes along with abilities
		and every item has durability. BaseItem is not intended to be used directly but dispatched
		from Data.get_item(index) to utilize a dictionary read from a json file. Activating the item
		is simply passes the call through to its ability. It will require a reference to the user of
		the ability.
	
	Dependencies: BaseAbility
"""

var current: Dictionary
var raw: Dictionary

func _init(data: Dictionary) -> void:
	raw = data
	current = raw
	if current.has("ability"):
		current.ability = Data.get_ability(raw.ability)
	match current.slot:
		"head":
			current.resists["head"] = 0
		"boots":
			current.resists["boots"] = 0
			current.resists["aoe"] = 0
			
func activate(host) -> void:
	current.ability.execute(host)
	
func consume_durability(c: int) -> void:
	current.durability -= c
	
func get_durability() -> int:
	return current.durability
	
func get_resist(r: String) -> int:
	if current.resists.has(r):
		return current.resists[r]
	else:
		return 0
		
func is_default() -> bool:
	return false

func take_damage(resist: String, count: int) -> void:
	if current.resists.has(resist) and current.resists[resist] > 0:
		current.resists[resist] -= count
	else:
		consume_durability(count)

func as_dict():
	var dict = current.duplicate(true)
	if dict.has("ability"):
		dict.ability = dict.ability.current.index
	return dict

func _notification(what):
	match what:
		NOTIFICATION_PREDELETE:
			if current.has("ability"):
				if ! current.ability is String:
					current.ability.queue_free()
