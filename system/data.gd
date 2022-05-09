extends Node

var abilities = {
	"High Jump" : preload("res://abilities/high_jump.tres"),
	"Draw Attack" : preload("res://abilities/draw_attack.tres"),
	"Treasure Sense" : preload("res://abilities/treasure_sense.tres")
}

var items = {
	"Debug Item" : preload("res://items/debug_item.tres"),
	"Katana" : preload("res://items/katana.tres"),
	"Test Item" : preload("res://items/item_data.tres"),
	"Wizard Hat" : preload("res://items/wizard_hat.tres"),
	"Bandana" : preload("res://items/bandana.tres")
}

var effects = {
	"Slow Fall" : preload("res://effects/effect.gd"),
	"Treasure Sense" : preload("res://effects/treasure_sense_effect.gd")
}
