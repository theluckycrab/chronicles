class_name TestItem
extends MeshInstance

enum Slots{HEAD, CHEST, GLOVES, LEGS, BOOTS}
export(Slots) var slot := Slots.CHEST
var mesh_file_path = "res://Blender/BaseHumanoid/pants.mesh"

func _init():
	name = "Balls"

func execute(host):
	var item = host.equip_item(self)
	host.add_force(Vector3.UP * 400)
	yield(host.get_tree().create_timer(1), "timeout")
	item.queue_free()
	
func set_skeleton(skel_path):
	skeleton = skel_path
#set the mesh
#hook up the skeleton
#keep the stats

#slot to slot
#items need functions
