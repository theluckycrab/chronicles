extends Control

var item_list = Data.reference.item_list
var icon = preload("res://world/ui/item_display.tscn")

onready var save_button = $Layout/Mid/HBoxContainer/Save
onready var exit_button = $Layout/Mid/HBoxContainer/Exit
onready var name_entry = $Layout/Mid/HBoxContainer2/NameEntry
onready var item_lists = [$Layout/Control/Left/HeadList, $Layout/Control/Left/ChestList, $Layout/Control/Left/GlovesList,\
		$Layout/Control/Left/LegsList, $Layout/Control/Left/BootsList, $Layout/Control/Left/MainhandList, $Layout/Control/Left/OffhandList]
onready var chat_color_button = $Layout/Mid/HBoxContainer2/ChatColorButton
onready var system_color_button = $Layout/Mid/HBoxContainer2/SystemColorButton

func _ready():
	for i in item_list:
		var nicon = icon.instance()
		nicon.item = i
		#$VBoxContainer.add_child(nicon)
	save_button.connect("button_down", self, "on_save")
	exit_button.connect("button_down", self, "on_exit")
	name_entry.connect("text_changed", self, "on_name_entry")
	var _discard = connect("visibility_changed", self, "on_visibility_changed")
	for i in item_lists:
		i.connect("item_selected", self, "on_item_selected")
		i.connect("item_unselected", self, "on_item_unselected")
		
		
func _physics_process(_delta):
	if visible:
		if Input.is_action_just_pressed("ui_cancel"):
			on_exit()
		

func on_save():
	for i in item_lists:
		if i.get_item_icon() != null:
			var d = i.get_item_icon().item
			Data.set_char_value("default", {slot=d.slot, index=d.index})
		else:
			Data.persistence.char_data.defaults.erase(i.category)
	Data.set_char_value("alias", $Layout/Mid/HBoxContainer2/NameEntry.text)
	Data.save_config_value("chat_color", $Layout/Mid/HBoxContainer2/ChatColorButton.color.to_html())
	Data.save_config_value("system_color", $Layout/Mid/HBoxContainer2/SystemColorButton.color.to_html())
	Data.full_save_char()
	on_exit()
	pass
	
	
func on_visibility_changed():
	if visible:
		Data.load_char_save(Data.get_char_value("alias"))
		var data = Data.get_char_data().duplicate(true)
		$Layout/Mid/Preview._ready()
		$Layout/Mid/Label2.update()
		$Layout/Mid/HBoxContainer2/NameEntry.text = data.alias
		if $Layout/Mid/HBoxContainer2/NameEntry.text == "New Character":
			$Layout/Mid/HBoxContainer2/NameEntry.text = "Enter a character name"
		chat_color_button.color = Color(Data.get_config_value("chat_color"))
		system_color_button.color = Color(Data.get_config_value("system_color"))
		for i in item_lists:
			for j in i.get_children():
				if data.defaults.has(i.category.to_lower()):
					if j.item.index == data.defaults[i.category.to_lower()]:
						j.modulate = Color.orange
						i.selected_icon = j
					else:
						j.modulate = Color.whitesmoke
	
	
	
func on_exit():
	hide()
	
	
func on_item_selected(index):
	$Layout/Mid/Preview.change_item(index)
	
func on_item_unselected(slot):
	$Layout/Mid/Preview.destroy(slot)


func on_name_entry(_words):
	Data.set_char_value("alias", $Layout/Mid/HBoxContainer2/NameEntry.text)
	$Layout/Mid/Label2.update()
