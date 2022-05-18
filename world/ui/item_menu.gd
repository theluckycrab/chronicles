extends Control

export var items = []
export var categories = ["Consumables", "Equipment", "Emote", "Chat"]
export var radius = 150

var current_category = null

onready var host = get_parent().get_parent()


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
	item_layout(categories)
	
	
func _physics_process(_delta) -> void:
	if Input.is_action_just_pressed("ui_right"):
		shift("right")
	elif Input.is_action_just_pressed("ui_left"):
		shift("left")
	elif Input.is_action_just_pressed("ui_accept"):
		if current_category == "Equipment":
			print(items[0])
			host.npc("equip", {source = "external", index = items[0].internal.index})
		for i in get_children():
			i.queue_free()
		_ready()
		
		
func item_layout(list:Array) -> void:
	if list.size() <= 0:
		return
	var pos = get_rect().size / 2
	var up = Vector2.UP
	var turn = deg2rad(360/list.size())
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
			lab.mouse_filter = Control.MOUSE_FILTER_PASS
			lab.connect("mouse_entered", self, "on_category_select", [lab.text])
		
		
func shift(dir:String) -> void:
	if !current_category:
		return
	if dir == "right":
		var n = items.front()
		items.pop_front()
		items.append(n)
	elif dir == "left":
		var n = items.back()
		items.pop_back()
		items.insert(0, n)
	for i in get_children():
		if i is Label:
			i.queue_free()
	on_category_select(current_category)
			

func on_category_select(category) -> void:
	current_category = category
	var new_list = []
	var filter = []
	
	for i in get_children():
		i.queue_free()
	
	match category:
		"Equipment":
			filter.append("Head")
			filter.append("Mainhand")
			filter.append("Offhand")
			filter.append("Boots")
			
	for i in items:
		if filter.has(i.visual.slot):
			new_list.append(i)
			
	item_layout(new_list)
