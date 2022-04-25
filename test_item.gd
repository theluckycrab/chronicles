class_name TestItem
extends MeshInstance

enum Slots{HEAD, CHEST, GLOVES, LEGS, BOOTS}

var stats = {
				slot = Slots.HEAD,
				mesh_file_path = "res://Blender/BaseHumanoid/pants.mesh",
				is_modified = false,
				item_name = "Balls",
				count = 1
}


func execute(host) -> void:
	var item = host.equip_item(self)
	host.add_force(Vector3.UP * 400)
	yield(host.get_tree().create_timer(1), "timeout")
	item.queue_free()
	
	
func set_skeleton(skel_path) -> void:
	skeleton = skel_path
