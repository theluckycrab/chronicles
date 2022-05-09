extends Control


export(NodePath) onready var inventory = get_node(inventory).inventory as Inventory
onready var off_list = $OffList
onready var main_list = $MainList
onready var boots_list = $BootsList
onready var hat_list = $HatList
onready var icon = preload("res://ui/item_icon.tscn")
var iterator = 0
onready var itList = $MainList

func _ready():
	generate_lists()
	
func _physics_process(delta):
	controls()
	
func show_list(list):
	itList.get_child(iterator).get_node("Selected").value = 0
	for i in list.get_children():
		i.visible = true
	if itList == list:
		iterator += 1
	else:
		itList = list
		iterator = 0
	if iterator < 0:
		iterator = itList.get_children().size() - 1
	elif iterator > itList.get_children().size() - 1:
		iterator = 0
	itList.get_child(iterator).get_node("Selected").value = 1
		
func hide_list(list):
	for i in list.get_children():
		i.visible = false
	list.get_child(0).visible = true

func generate_lists():
	for i in inventory.items:
		var nicon = icon.instance()
		nicon.item = i
		nicon.visible = false
		match i.visual.slot:
			"Head":
				hat_list.add_child(nicon)
				nicon.get_node("Icon").flip_v = true
				$HatList/ItemIcon/Icon.flip_v = true
			"Boots":
				boots_list.add_child(nicon)
			"Mainhand":
				main_list.add_child(nicon)
			"Offhand":
				off_list.add_child(nicon)
				
func controls():
	var buttons = ["ui_left", "ui_right", "ui_down", "ui_up"]
	for i in buttons:
		if Input.is_action_just_pressed(i):
			hide_list(hat_list)
			hide_list(main_list)
			hide_list(boots_list)
			hide_list(off_list)
	if Input.is_action_just_pressed("ui_left"):
		show_list(off_list)
	elif Input.is_action_just_pressed("ui_right"):
		show_list(main_list)
	elif Input.is_action_just_pressed("ui_down"):
		show_list(boots_list)
	elif Input.is_action_just_pressed("ui_up"):
		show_list(hat_list)

func get_item():
	return itList.get_child(iterator).item
