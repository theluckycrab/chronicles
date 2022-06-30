extends Resource

export var effect_name: String = "Skates"
var source = null
var index = "skates"


func enter(host: Object) -> void:
	if host.state_machine.state_dict.has("walk"):
		host.state_machine.override("walk", load("res://data/effects/skate_state.gd").new())
	pass

	
func exit(host: Object) -> void:
	if host.state_machine.state_dict.has("walk"):
		host.state_machine.override_dict.erase("walk")
	pass


func execute(host: Object) -> void:
	pass
