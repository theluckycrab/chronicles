extends Control

export var items: Array = []
export var equipment: Array = []
export var consumables: Array = []
export onready var emotes: Array = ["Sit_Floor", "APose", "Item", "Taunt"]
export var categories: Array = ["consumables", "equipment", "emote", "chat"]
export var radius: int = 150

signal category_changed

var active: bool = false setget , get_active
var current_category = null setget set_category

onready var host = get_parent().get_parent()


func controls() -> void:
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
	elif Input.is_action_just_pressed("item_category_3"):
		set_category("emote")
		
	if current_category == "categories":
		if Input.is_action_just_released("mainhand"):
			set_category(categories[1])
		elif Input.is_action_just_released("boots"):
			set_category(categories[2])
		elif Input.is_action_just_released("head"):
			set_category(categories[0])

	elif current_category != null and current_category != "categories":
		if Input.is_action_just_released("item_scroll_right"):
			match current_category:
				"equipment":
					shift("right", equipment)
				"emote":
					shift("right", emotes)
				"consumables":
					shift("right", consumables)
		elif Input.is_action_just_released("item_scroll_left"):
			match current_category:
				"equipment":
					shift("left", equipment)
				"emote":
					shift("left", emotes)
				"consumables":
					shift("left", consumables)
		elif Input.is_action_just_released("item_scroll_confirm"):
			if current_category == "equipment":
				if !items.empty():
					host.equip(equipment[0])
			if current_category == "emote":
				if !emotes.empty():
					host.get_state("emote").animation = emotes[0]
					host.set_state("emote")
			if current_category == "consumables":
				if !consumables.empty():
					host.set_state(consumables[0].active)
					host.inventory.items.erase(consumables[0])
			set_category(null)


func _ready() -> void:
	current_category = null
	
	
func _physics_process(_delta) -> void:
	controls()
	
	
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
			icon.item = i.get_index()
			add_child(icon)
			icon.rect_position = pos + up * radius
			icon.rect_scale *= 0.5
		elif i is String:
			var lab = Label.new()
			add_child(lab)
			lab.text = i
			lab.rect_position = pos + up * radius
			lab.rect_position.x -= i.length() * 2.5
		
		
func shift(dir:String, list) -> void:
	if current_category == null or list.empty():
		return
	if dir == "right":
		var n = list.front()
		list.pop_front()
		list.append(n)
	elif dir == "left":
		var n = list.back()
		list.pop_back()
		list.insert(0, n)
	refresh_category()
	

func reset() -> void:
	for i in get_children():
			i.queue_free()
	current_category = null


func set_category(category) -> void:#string or null
	if category != current_category:
		fetch_items()
		current_category = category
		build_lists()
		refresh_category()


func refresh_category() -> void:
	for i in get_children():
		i.queue_free()
	match current_category:
		"categories":
			item_layout(categories)
			return
		"equipment":
			item_layout(equipment)
			return
		"emote":
			item_layout(emotes)
			return
		"consumables":
			item_layout(consumables)
			return


func get_active() -> bool:
	return current_category != null
	
	
func fetch_items():
	items = host.inventory.get_item_list()

func build_lists():
	match current_category:
		"categories":
			return
		"equipment":
			var new_list = []
			var filter = []
			filter.append("Head")
			filter.append("Mainhand")
			filter.append("Offhand")
			filter.append("Boots")
			for i in items:
				if filter.has(i.get_slot()):
					new_list.append(i)
			equipment = new_list
			return
		"emote":
			return
		"consumables":
			var new_list = []
			var filter = []
			filter.append("Consumable")
			for i in items:
				if filter.has(i.get_slot()):
					new_list.append(i)
			consumables = new_list
			return
