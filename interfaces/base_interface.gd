extends Node
class_name BaseInterface

"""
	The purpose of an interface, such as IActor, is to provide a reliable set of functions through 
		which objects can expect to interact with each other. Interactable items, state machines, 
		and abilities will all want to know what functions they can safely call on a Mobile 
		(or other actor). GDScript does not support actual interfaces. This script checks its owner 
		for the functions listed here and then adds that owner to a group, if all functions are 
		found. Objects that wish to provide functionality to actors will check 
		host.is_in_group("actors") to ensure the contract is met. It's a hack, a workaround, but you
		should copy/paste all of these functions for every object you want to be involved in actor 
		things.
		
		Think of this as a shorthand for running host.has_method("emote") all over.
"""

var host

func _init(h, tag = "interface"):
	host = h
	var implemented = true
	for i in get_method_list():
		if ! i.name.begins_with("_") and ! host.has_method(i.name):
			print(host.to_string(), " claims i_", tag, " but does not implement ", i.name, "()")
			implemented = false
	if implemented:
		host.add_to_group(tag)
	host.connect("tree_exiting", self, "_on_host_exit")
	
func _on_host_exit():
	queue_free()
