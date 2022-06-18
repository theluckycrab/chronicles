extends Control

func _ready():
	var alias = Data.get_saved_char_value("alias")
	Data.load_char_save(alias)
	var char_data = Data.persistence.char_data.duplicate(true)
	for i in char_data.defaults:
		$Viewport/Camera/Armature.equip({index=char_data.defaults[i]})
	#$Viewport/Camera/Armature.equip({index="wizard_hat"})

func change_item(i):
	$Viewport/Camera/Armature.equip({index = i})
	
func destroy(slot: String) -> void:
	$Viewport/Camera/Armature.destroy(slot)
