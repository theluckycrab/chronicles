extends Node
class_name BaseAbility

"""
	These abilities are specific to the Delonda structure, where each ability fits into a particular
		slot. BaseAbility is not intended to be used directly but dispatched from 
		Data.get_ability(index) to utilize a dictionary read from a json file. As abilities access
		the IActor functions, they'll need a reference to the user. The user will need to be in the
		"actors" group.
		
	Dependencies : 
"""

var current: Dictionary
var raw: Dictionary

func _init(data: Dictionary) -> void:
	raw = data
	current = raw
	
func execute(host) -> void:
	if ! host.is_in_group("actors"):
		print(host, " attempted to use an ability but is not an actor.")
		return
	host.emote(current.animation)
	match current.type:
		"projectile":
			pass
		"sight":
			var color = Color(current.color_r, current.color_g, current.color_b, .5)
			for i in current.targets:
				for j in host.get_tree().get_nodes_in_group(i):
					if j.has_method("highlight"):
						j.highlight(color)
