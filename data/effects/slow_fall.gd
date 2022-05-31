class_name SlowFallEffect
extends Resource

export var effect_name: String = "Slow Fall"
var source = null
var index = "slow_fall"


func enter(_host: Object) -> void:
	pass

	
func exit(_host: Object) -> void:
	pass


func execute(host: Object) -> void:
	if !host.is_on_floor():
		host.add_force(Vector3.UP * 7)
	pass
