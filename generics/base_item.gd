extends Reference
class_name BaseItem

var current: Dictionary
var raw: Dictionary

func _init(data: Dictionary) -> void:
	raw = data
	current = raw
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
		
func get_slot() -> String:
	return current.slot
		
func is_default() -> bool:
	return false

func take_damage(resist: String, count: int) -> void:
	if current.resists.has(resist) and current.resists[resist] > 0:
		current.resists[resist] -= count
	else:
		consume_durability(count)

func as_dict():
	var dict = current.duplicate(true)
	if dict.has("ability") and dict.ability is BaseAbility:
		dict.ability = dict.ability.current.index
	return dict

func _notification(what):
	match what:
		NOTIFICATION_PREDELETE:
			if current.has("ability"):
				if ! current.ability is String:
					current.ability.queue_free()

func get_animation_overrides() -> Dictionary:
	return current.animations

func get_damage_profile() -> DamageProfile:
	var dp
	if current.has("damage"):
		dp = DamageProfile.new(current.damage)
	else:
		dp = DamageProfile.new()
	return dp
