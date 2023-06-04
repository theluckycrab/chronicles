extends Spatial
class_name BaseBuff

var raw = {}
var current = {}
var host = null
var done = false
var paused = false
var tick_rate = 1.0
var time_elapsed = tick_rate

func _init(data):
	raw = data
	current = raw
	if ! current.has("constant"):
		current["constant"] = {}
	if ! current.has("tick"):
		current["tick"] = {}
	
func can_exit():
	return done
	
func update(delta):
	time_elapsed += delta
	if done or current.duration == 0:
		exit()
	elif ! paused and time_elapsed > tick_rate:
		time_elapsed = 0.0
		tick()
	constant(delta)
	
func exit():
	undo()
	queue_free()
	
func pause():
	paused = true
	
func unpause():
	paused = false
	
func set_host(who):
	host = who
	
func get_index():
	return current.index
	
##############
	
func enter():
	pass
	
func constant(delta):
	for i in current.constant:
		call(i, current.constant[i])
	pass
	
func tick():
	if current.duration > 0:
		current.duration -= 1
	for i in current.tick:
		call(i, current.tick[i])
	pass
	
func undo():
	for i in current.tick:
		match i:
			"highlight":
				var args = current.tick.highlight
				args.color = "reset"
				highlight(args)
	pass

############

func gravity(args):
	if host.get_state() == "Fall":
		var g = host.force.y
		host.add_force(Vector3.UP * (-g * args.mod))

func highlight(args):
	for i in args.factions:
		var units = get_tree().get_nodes_in_group(i)
		for each in units:
			if each.has_method("highlight"):
				each.highlight(args.color)
