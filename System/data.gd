extends Node

var abilities = {
	"High Jump" : preload("res://Abilities/high_jump.tres"),
	"Draw Attack" : preload("res://Abilities/draw_attack.tres"),
	"Treasure Sense" : preload("res://Abilities/treasure_sense.tres")
}

var items = {
	"Debug Item" : preload("res://Items/debug_item.tres"),
	"Katana" : preload("res://Items/katana.tres"),
	"Test Item" : preload("res://Items/item_data.tres"),
	"Wizard Hat" : preload("res://Items/wizard_hat.tres"),
	"Bandana" : preload("res://Items/bandana.tres")
}

var effects = {
	"Slow Fall" : preload("res://Effects/effect.gd"),
	"Treasure Sense" : preload("res://Effects/treasure_sense_effect.gd")
}
