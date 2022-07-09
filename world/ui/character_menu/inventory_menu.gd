extends Control

signal inventory_changed

var icon = preload("res://world/ui/item_icon.tscn")
var inventory = []
var filter_delay = 0.25

onready var list = $VSplitContainer/ScrollContainer/GridContainer
onready var filter = $VSplitContainer/Filter
onready var filter_timer = Timer.new()

func _ready():
	$VSplitContainer/ScrollContainer.connect("item_dropped", self, "on_item_dropped")
	filter.connect("text_changed", self, "on_filter_set")
	filter_timer.autostart = false
	filter_timer.one_shot = true
	add_child(filter_timer)
	filter_timer.connect("timeout", self, "on_filter_timer")
	filter_timer.start(filter_delay)
	layout()
	
func on_filter_set(_text):
	filter_timer.start(filter_delay)
	pass
	
	
func layout():
	for t in list.get_children():
		t.queue_free()
		
	for i in inventory:
		var nicon = icon.instance()
		list.add_child(nicon)
		nicon.refresh(i)
		nicon.connect("exited_inventory", self, "on_exited_inventory")
	pass

func has_filters(dictionary, filters):
	if filters.empty():
		return true
	for i in filters:
		for j in dictionary.values():
			if j is String and i in j:
				return true
	return false

func on_filter_timer():
	var text = $VSplitContainer/Filter.text
	apply_filter(text)
	pass
	
func apply_filter(text):
	text = text.split(",", false)
	for i in list.get_children():
		if has_filters(Data.reference.item_list[i.item.index], text):
			i.show()
		else:
			i.hide()

func on_item_dropped(data):
	var i = icon.instance()
	i.item = data.item
	list.add_child(i)
	i.connect("exited_inventory", self, "on_exited_inventory")
	data.source.emit_signal("exited_inventory", data.source)
	inventory.append(data.item)
	emit_signal("inventory_changed", inventory)
	layout()

func on_exited_inventory(whichcon):
	print(name, " ", whichcon)
	inventory.erase(whichcon.item)
	emit_signal("inventory_changed", inventory)
	whichcon.queue_free()
	layout()
