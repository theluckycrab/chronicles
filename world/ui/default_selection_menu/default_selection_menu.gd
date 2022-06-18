extends Control

var item_list = Data.reference.item_list
var icon = preload("res://world/ui/item_display.tscn")

onready var save_button = $Layout/Mid/HBoxContainer/Save
onready var exit_button = $Layout/Mid/HBoxContainer/Exit
onready var name_entry = $Layout/Mid/NameEntry
onready var item_lists = [$Layout/Left/Itemlist, $Layout/Left/Itemlist2, \
		$Layout/Left/Itemlist3, $Layout/Left/Itemlist4,\
		$Layout/Right/Itemlist5, $Layout/Right/Itemlist6,\
		$Layout/Right/Itemlist7]


func _ready():
	for i in item_list:
		var nicon = icon.instance()
		nicon.item = i
		#$VBoxContainer.add_child(nicon)
	save_button.connect("button_down", self, "on_save")
	exit_button.connect("button_down", self, "on_exit")
	name_entry.connect("text_changed", self, "on_name_entry")
	connect("visibility_changed", self, "on_visibility_changed")
	for i in item_lists:
		i.connect("item_selected", self, "on_item_selected")
		i.connect("item_unselected", self, "on_item_unselected")
		

func on_save():
	for i in item_lists:
		if i.get_item_icon() != null:
			var d = i.get_item_icon().item
			Data.set_char_value("default", {slot=d.slot, index=d.index})
	Data.set_char_value("alias", $Layout/Mid/NameEntry.text)
	Data.full_save_char()
	on_exit()
	pass
	
	
func on_visibility_changed():
	if visible:
		Data.load_char_save(Data.get_char_value("alias"))
		var data = Data.get_char_data().duplicate(true)
		$Layout/Mid/Preview._ready()
		$Layout/Mid/Label2.update()
		$Layout/Mid/NameEntry.text = data.alias
		for i in item_lists:
			for j in i.get_children():
				if data.defaults.has(i.category):
					if j.item.index == data.defaults[i.category]:
						j.modulate = Color.lightgoldenrod
						i.selected_icon = j
	
	
	
func on_exit():
	hide()
	
	
func on_item_selected(index):
	$Layout/Mid/Preview.change_item(index)
	
func on_item_unselected(slot):
	$Layout/Mid/Preview.destroy(slot)


func on_name_entry(_words):
	Data.set_char_value("alias", $Layout/Mid/NameEntry.text)
	$Layout/Mid/Label2.update()
