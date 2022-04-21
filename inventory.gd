extends Spatial

var items = {"Donger":TestItem.new()}

func use_item():
	items["Donger"].execute()
	pass
