extends Control

signal item_added
signal item_removed

var icon = preload("res://world/ui/item_icon.tscn")
var inventory = []
var filter_delay = 0.15

onready var list = $VSplitContainer/ScrollContainer/GridContainer
onready var scroll_container = $VSplitContainer/ScrollContainer
onready var filter = $VSplitContainer/Filter
onready var filter_timer = Timer.new()

func _ready():
	scroll_container.connect("item_dropped", self, "on_item_dropped")
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
		nicon.connect("item_removed", self, "on_item_removed")
		nicon.refresh(i)
	on_filter_timer()
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
		for j in text:
			if j in i.item.tags:
				i.show()
		if ! ":pouch:" in text:
			if ":pouch:" in i.item.tags:
				i.hide()

func on_item_dropped(data):
	data.source.declare_removed()
	emit_signal("item_added", data.item)

func on_item_removed(whichcon):
	emit_signal("item_removed", whichcon.item)
