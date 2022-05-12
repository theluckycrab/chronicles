extends Node
var reference = ReferenceList.new()

func _ready():
	print("building reference database")
	reference.build_list("res://data")

var abilities = {
	"High Jump" : preload("res://data/abilities/high_jump.tres"),
	"Draw Attack" : preload("res://data/abilities/draw_attack.tres"),
	"Treasure Sense" : preload("res://data/abilities/treasure_sense.tres")
}

var items = {
	"Debug Item" : preload("res://data/items/debug_item.tres"),
	"Katana" : preload("res://data/items/katana.tres"),
	"Test Item" : preload("res://data/items/item_data.tres"),
	"Wizard Hat" : preload("res://data/items/wizard_hat.tres"),
	"Bandana" : preload("res://data/items/bandana.tres")
}

var effects = {
	"Slow Fall" : preload("res://data/effects/effect.gd"),
	"Treasure Sense" : preload("res://data/effects/treasure_sense_effect.gd")
}
