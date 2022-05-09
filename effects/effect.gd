extends Spatial
class_name SlowFallEffect

var effect_name = "Slow Fall"
var source = null

func enter(host):
	pass
	
func exit(host):
	pass

func execute(host):
	if !host.is_on_floor():
		host.add_force(Vector3.UP * 7)
	pass
