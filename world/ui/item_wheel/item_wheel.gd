extends Control

export(NodePath) onready var inventory = get_node(inventory)
onready var item_list = inventory.items
onready var host = inventory.host
var icon = preload("res://world/ui/item_wheel/mouse_over_item_icon.tscn")
var selected = null
var mouse_mode = Input.MOUSE_MODE_VISIBLE
var mouse_motion_vector = Vector2.ZERO
var right_stick_vector = Vector2.ZERO

func get_item_list(pouch=true):
	var new_list = []
	for i in inventory.items:
		if pouch:
			if i.has_tag(":pouch:"):
				new_list.append(i)
		else:
			new_list.append(i)
	item_list = new_list
	
func _input(_event):
	right_stick_vector.x = Input.get_joy_axis(1, JOY_AXIS_2)
	right_stick_vector.y = Input.get_joy_axis(1, JOY_AXIS_3)
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("item_mod"):
		update()
		visible = true
		mouse_mode = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_released("item_mod"):
		release()
		Input.set_mouse_mode(mouse_mode)
	var wasd = right_stick_vector
	var angle = atan2(wasd.x, -wasd.y)
	var dir = Vector2.UP.rotated(angle).normalized()
	if right_stick_vector.length() > 0.25:
		warp_mouse((dir * 150) + Vector2(16,16))
	
func update():
	get_item_list()
	layout()
	
func layout():
	if item_list.empty():
		return
	var angle = 360 / item_list.size()
	var dir = Vector2.UP
	
	for i in item_list:
		var nicon = icon.instance()
		nicon.item = i
		add_child(nicon)
		nicon.connect("mouse_entered", self, "select", [nicon])
		nicon.connect("mouse_exited", self, "deselect", [nicon])
		nicon.rect_position = dir * 150
		dir = dir.rotated(deg2rad(angle))

func select(ni):
	selected = ni
	
func deselect(_ni):
	selected = null
	
func release():
	hide()
	if selected == null:
		for i in get_children():
			i.queue_free()
		return
	if selected.item.slot == "consumable":
		host.set_state(selected.item.get_active())
	else:
		host.equip(selected.item)
	for i in get_children():
		i.queue_free()
	selected = null
