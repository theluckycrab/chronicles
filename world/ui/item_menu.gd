extends Control

export var items = []
export var categories = ["consumables", "equipment", "emote", "chat"]
export var radius = 150

var current_category = null setget set_category
signal category_changed

onready var host = get_parent().get_parent()


func _ready() -> void:
	current_category = null
	var _discard = connect("category_changed", self, "on_category_changed")
	items = [
		Data.get_reference_instance("bandana"),
		Data.get_reference_instance("katana"),
		Data.get_reference_instance("wizard_hat"),
		Data.get_reference_instance("wizard_hat"),
		Data.get_reference_instance("wizard_hat"),
		Data.get_reference_instance("wizard_hat"),
		Data.get_reference_instance("wizard_hat")
	]
		
func item_layout(list:Array) -> void:
	if list.size() <= 0:
		return
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
			lab.mouse_filter = Control.MOUSE_FILTER_PASS
			lab.connect("mouse_entered", self, "on_category_select", [lab.text])
		
		
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
	for i in get_children():
		if i is Label:
			i.queue_free()
	refresh_category()
			

func on_category_changed(category) -> void:
	current_category = category
	var new_list = []
	var filter = []
	
	for i in get_children():
		i.queue_free()
	
	match category:
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

func reset():
	for i in get_children():
			i.queue_free()
	current_category = null

func set_category(category):
	if category != current_category:
		current_category = category
		emit_signal("category_changed", category)

func refresh_category():
	on_category_changed(current_category)
