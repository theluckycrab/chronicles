extends Control

export(NodePath) onready var host = get_node(host)
var active = false setget , get_active

func _physics_process(delta):
	controls()

func controls():
	if !self.active:
		if Input.is_action_just_pressed("ability_mod"):
			show_activate()
		elif Input.is_action_just_pressed("destroy_mod"):
			show_destroy()
	if $DestroyOverlay.visible:
		for i in ["head", "mainhand", "offhand", "boots"]:
			if Input.is_action_just_pressed(i):
				host.destroy(i.capitalize())
				call_deferred("show_normal")
				return
	elif $ActivateOverlay.visible:
		for i in ["head", "mainhand", "offhand", "boots"]:
			if Input.is_action_just_pressed(i):
				host.activate_item_slot(i.capitalize())
				call_deferred("show_normal")
				return
	for i in ["ability_mod", "destroy_mod"]:
		if Input.is_action_just_released(i):
			show_normal()
			return

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

func get_active():
	return $DestroyOverlay.visible or $ActivateOverlay.visible
