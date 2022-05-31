extends Control

export var items = []
export var categories = ["consumables", "equipment", "emote", "chat"]
export var radius = 150

var active = false setget , get_active
var current_category = null setget set_category
signal category_changed

onready var host = get_parent().get_parent()


func controls():
	if !Input.is_action_pressed("item_mod"):
		if Input.is_action_just_released("item_mod"):
			set_category(null)
			return
		
	if Input.is_action_just_pressed("item_mod")\
			and !Input.is_action_pressed("item_category_1")\
			and !Input.is_action_pressed("item_category_2")\
			and !Input.is_action_pressed("item_category_3")\
			and !Input.is_action_pressed("item_category_4"):
		set_category("categories")
	elif Input.is_action_just_pressed("item_category_1"):
		set_category("consumables")
	elif Input.is_action_just_pressed("item_category_2"):
		set_category("equipment")
		
	if current_category == "categories":
		if Input.is_action_just_released("item_scroll_right"):
			set_category(categories[1])

	elif current_category == "equipment":
		if Input.is_action_just_released("item_scroll_right"):
			shift("right")
		elif Input.is_action_just_released("item_scroll_left"):
			shift("left")
		elif Input.is_action_just_released("item_scroll_confirm"):
			host.equip(items[0])
	return 


func _ready() -> void:
	current_category = null
	items = [
		Data.get_reference_instance("bandana"),
		Data.get_reference_instance("katana"),
		Data.get_reference_instance("wizard_hat"),
		Data.get_reference_instance("wizard_hat"),
		Data.get_reference_instance("wizard_hat"),
		Data.get_reference_instance("wizard_hat"),
		Data.get_reference_instance("wizard_hat")
	]
	
func _physics_process(delta):
	controls()
		
func item_layout(list:Array) -> void:
	if list.size() <= 0:
		return
	print(list)
	var pos = get_rect().size / 2
	var up = Vector2.UP
	var turn = deg2rad(360.0/list.size())
	up = up.rotated(-turn)
	for i in list:
		up = up.rotated(turn)
		if i is Item:
			var icon = load("res://world/ui/item_icon.tscn").instance()
			icon.item = i.internal.index
			add_child(icon)
			icon.rect_position = pos + up * radius
			icon.rect_scale *= 0.5
		elif i is String:
			var lab = Label.new()
			add_child(lab)
			lab.text = i
			lab.rect_position = pos + up * radius
			lab.rect_position.x -= i.length() * 2.5
		
		
func shift(dir:String) -> void:
	if current_category == null:
		return
	if dir == "right":
		var n = items.front()
		items.pop_front()
		items.append(n)
	elif dir == "left":
		var n = items.back()
		items.pop_back()
		items.insert(0, n)
	refresh_category()
	

func reset():
	for i in get_children():
			i.queue_free()
	current_category = null

func set_category(category):
	if category != current_category:
		current_category = category
		refresh_category()

func refresh_category():
	var new_list = []
	var filter = []
	
	for i in get_children():
		i.queue_free()
	
	match current_category:
		"categories":
			item_layout(categories)
			return
		"equipment":
			filter.append("Head")
			filter.append("Mainhand")
			filter.append("Offhand")
			filter.append("Boots")
			
	for i in items:
		if filter.has(i.visual.slot):
			new_list.append(i)
	item_layout(new_list)


func get_active():
	return current_category != null

func show_category(input):
	var cat = null
	match input:
		"item_mod":
			cat = "categories"
		"item_category_1":
			cat = "consumables"
		"item_category_2":
			cat = "equipment"
		"item_category_3":
			cat = "emote"
		"item_category_4":
			cat = "chat"
	set_category(cat)
