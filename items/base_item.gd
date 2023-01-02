extends Node
class_name BaseItem

var raw
var current

func _init(data):
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
		

func activate(host):
	current.ability.execute(host)

func take_damage(resist, count):
	if current.resists.has(resist) and current.resists[resist] > 0:
		current.resists[resist] -= count
		print("%s resist %s %s // %s remains" % [current.name, resist, count, get_resist(resist)])
	else:
		consume_durability(count)

func is_default():
	return false
	
func get_resist(r):
	if current.resists.has(r):
		return current.resists[r]
	else:
		return 0
	
func get_durability():
	return current.durability

func consume_durability(c):
	current.durability -= c
	print(current.name, " durability [", current.durability, "]")
	if current.durability < 0:
		print(current.index, " would have been destroyed")
