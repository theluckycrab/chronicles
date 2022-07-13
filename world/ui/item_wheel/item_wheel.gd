extends Control

export(NodePath) onready var inventory = get_node(inventory)
onready var item_list = inventory.items
onready var host = inventory.host
var icon = preload("res://world/ui/item_wheel/mouse_over_item_icon.tscn")
var selected = null
var mouse_mode = Input.MOUSE_MODE_VISIBLE

func get_item_list(pouch=true):
	var new_list = []
	for i in inventory.items:
		if pouch:
			if i.has_tag(":pouch:"):
				new_list.append(i)
		else:
			new_list.append(i)
	item_list = new_list
	
func _physics_process(delta):
	if Input.is_action_just_pressed("item_mod"):
		update()
		visible = true
		mouse_mode = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_released("item_mod"):
		release()
		Input.set_mouse_mode(mouse_mode)
	
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
		dir = dir.rotated(angle)
		print(dir)

func select(ni):
	selected = ni
	
func deselect(ni):
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
