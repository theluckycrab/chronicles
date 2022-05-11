extends VBoxContainer

var category = preload("res://player_inventory_display_category.tscn")
export(NodePath) onready var host
var items
var iterator = 0
var item_select = 0

func _ready():
#	call_deferred("get_categories")
	call_deferred("make_icons")
	
	
func _physics_process(delta):
	pass
#	controls()
#	for i in get_children():
#		i.get_node("CategoryIndicator").modulate = Color.transparent
#		for j in i.get_node("ItemList").get_children():
#			j.modulate = Color.white


#	get_child(iterator).get_node("CategoryIndicator").modulate = Color.red
#	if get_child(iterator).get_node("ItemList").get_children().size() > item_select:
#		get_child(iterator).get_node("ItemList").get_child(item_select).modulate = Color.red
	
	
func get_categories():
	host = get_node(host)
	items = host.inventory.items
	var cats = []
	for i in items:
		var label = Label.new()
		$Category/ItemList.add_child(label)
		label.text = i.stats.item_name
		for j in i.stats.tags:
			if ! cats.has(j):
				cats.append(j)
	print(cats)
	for i in cats:
		var cat = category.instance()
		add_child(cat)
		cat.get_node("CategoryIndicator").modulate = Color.transparent
		cat.get_node("CategoryTitle").text = i
		for j in items:
			if j.has_tag(i):
				var label = Label.new()
				cat.get_node("ItemList").add_child(label)
				label.name = "Item"
				label.text = j.stats.item_name
				

func controls():
	if Input.is_action_just_pressed("ui_up"):
		iterator -= 1
	elif Input.is_action_just_pressed("ui_down"):
		iterator += 1
	if iterator > get_children().size() -1:
		iterator = 0
	elif iterator < 0:
		iterator = get_children().size() -1
		
	var list = get_child(iterator).get_node("ItemList")
#	print(str(item_select) + " // " + str(list.get_children().size()))
	if Input.is_action_just_pressed("ui_left"):
		item_select -= 1
	elif Input.is_action_just_pressed("ui_right"):
		item_select += 1
	if item_select > list.get_children().size() -1:
		item_select = 0
	elif item_select < 0:
		item_select = list.get_children().size() -1
		
	if Input.is_action_just_pressed("ui_accept"):
		get_item()

func get_item():
	print(get_child(iterator).get_node("ItemList").get_child(item_select).text)

func make_icons():
	host = get_node(host)
	for i in host.inventory.items:
		var icon = preload("res://item_display.tscn").instance()
		icon.item = i
		host.get_node("ItemList").add_child(icon)
