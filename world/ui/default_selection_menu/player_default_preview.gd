extends Control

func _ready():
	$Viewport/Camera/Armature.equip({index="wizard_hat"})

func change_item(i):
	$Viewport/Camera/Armature.equip({index = i})
