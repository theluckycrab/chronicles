extends BaseEffect
class_name EquipEffect

func _init(data, args={}).(data, args):
	pass

func _ready():
	host.npc("equip", { "base_item":current.item, "mesh":current.mesh})
	pass
	
