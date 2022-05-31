extends VBoxContainer

func clear_list():
	for i in get_children():
		i.queue_free()
		
func build_list(items):
	for i in items:
		var button = Button.new()
		add_child(button)
		button.connect("button_down", self, "on_button", [i])
		button.text = i.get_name()
		
func on_button(item):
#	item = item.replace(" ", "_")
#	item = item.to_lower()
#	var args = {item = item,
#			}
#	Network.relay_signal("item_equipped", args)
	get_parent().get_parent().npc("equip", {item = item})
