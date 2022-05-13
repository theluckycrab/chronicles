extends VBoxContainer

func clear_list():
	for i in get_children():
		i.queue_free()
		
func build_list(items):
	for i in items:
		var button = Button.new()
		add_child(button)
		button.connect("button_down", self, "on_button", [i.visual.item_name])
		button.text = i.visual.item_name
		
func on_button(item):
#	item = item.replace(" ", "_")
#	item = item.to_lower()
#	var args = {item = item,
#			}
#	Network.relay_signal("item_equipped", args)
	var i = Data.get_reference(item)
	get_parent().get_parent().armature.rpc("equip", i)
