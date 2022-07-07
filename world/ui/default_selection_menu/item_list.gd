extends HBoxContainer

signal item_selected
signal item_unselected

export(String) var category = "Head"
var item_list = Data.reference.item_list
var icon = preload("res://world/ui/item_display.tscn")
var selected_icon = null

func _ready():
	for i in item_list:
		var item = Data.get_item(i)
		if item.get_slot() == category.to_lower():
			var nicon = icon.instance()
			nicon.item = i
			add_child(nicon)
			nicon.connect("button_down", self, "on_button_down")
			if ["Chest", "Gloves", "Legs"].has(category):
				nicon.get_node("VBoxContainer/Ability").visible = false
			

func on_button_down(which):
	if which == selected_icon:
		selected_icon.modulate = Color.whitesmoke
		emit_signal("item_unselected", category)
		selected_icon = null
		return
	else:
			if selected_icon != null:
				selected_icon.modulate = Color.whitesmoke
			selected_icon = which
			which.modulate = Color.orange
			emit_signal("item_selected", selected_icon.item.index)
	
	
func get_item_icon():
	return selected_icon
