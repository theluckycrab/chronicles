extends HBoxContainer

signal item_selected

export(String) var category = "Head"
var item_list = Data.reference.item_list
var icon = preload("res://world/ui/item_display.tscn")
var selected_icon = null

func _ready():
	for i in item_list:
		var item = Data.get_item(i)
		if item.slot == category:
			var nicon = icon.instance()
			nicon.item = i
			add_child(nicon)
			nicon.connect("button_down", self, "on_button_down")
			

func on_button_down(which):
	if selected_icon:
		selected_icon.modulate = Color.whitesmoke
	selected_icon = which
	selected_icon.modulate = Color.lightgoldenrod
	emit_signal("item_selected", selected_icon.item.index)

func get_item_icon():
	print("selected icon")
	return selected_icon
