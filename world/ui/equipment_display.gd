extends Control
export(NodePath) onready var host = get_node(host)

func show_destroy():
	$ActivateOverlay.visible = false
	$DestroyOverlay.visible = true
	
func show_activate():
	$DestroyOverlay.visible = false
	$ActivateOverlay.visible = true
	
func show_normal():
	$ActivateOverlay.visible = false
	$DestroyOverlay.visible = false
	
func refresh():
	for i in host.armature.equipment:
		var icon = null
		match host.armature.equipment[i].visual.slot:
			"Head":
				icon = $HeadIcon
			"Mainhand":
				icon = $MainIcon
			"Offhand":
				icon = $OffIcon
			"Boots":
				icon = $BootsIcon
		if icon:
			icon.refresh(host.armature.equipment[i].internal.index)
