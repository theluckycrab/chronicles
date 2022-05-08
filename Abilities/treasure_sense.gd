extends Ability

var active = false
var base = 0
var zoom

func _init():
	ability_name = "Treasure Sense"

func execute(host) -> void:
	if !active:
		host.add_passive("Treasure Sense")
	else:
		host.remove_passive("Treasure Sense")
	active = !active
	pass
