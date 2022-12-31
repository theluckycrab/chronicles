extends Node
class_name BaseAbility

var raw
var current

func _init(data):
	raw = data
	current = raw
	
func execute(host):
	host.emote(current.animation)
	match current.type:
		"projectile":
			var args = {}
			args["uuid"] = "test_room"
			args["function"] = "spawn"
			args["unit"] = "base_projectile"
			args["spawn_args"] = current
			args["spawn_args"]["facing"] = host.armature.rotation.y
			var offset = Vector3(current.offset_x, current.offset_y, current.offset_z)
			args["position"] = host.global_transform.origin + offset.rotated(Vector3.UP, host.armature.rotation.y)
			Server.npc(args)
		"sight":
			var color = Color(current.color_r, current.color_g, current.color_b, .5)
			for i in current.targets:
				for j in host.get_tree().get_nodes_in_group(i):
					if j.has_method("highlight"):
						j.highlight(color)
		"buff":
			host.add_effect(current)
