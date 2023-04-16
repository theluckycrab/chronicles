extends Node
class_name BaseAbility

var current: Dictionary
var raw: Dictionary

func _init(data: Dictionary) -> void:
	raw = data
	current = raw
	
func execute(host) -> void:
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
