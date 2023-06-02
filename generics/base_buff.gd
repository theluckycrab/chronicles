extends Spatial
class_name BaseBuff

var raw = {}
var current = {}
var timer = Timer.new()
var host = null
var done = false
var time_elapsed = 0.0
var tick_rate = 1.0

func _init(data):
	raw = data
	current = raw
	
func _ready():
	timer.autostart = false
	timer.one_shot = bool(current.duration)
	add_child(timer)
	timer.connect("timeout", self, "on_timeout")
	timer.start(current.duration)
	enter()
	
func _process(delta):
	time_elapsed += delta
	if done:
		exit()
	elif ! timer.is_stopped() and time_elapsed > tick_rate:
		tick()
		time_elapsed = 0.0
	constant(delta)
	pass
	
func on_timeout():
	done = true
	
func exit():
	undo()
	queue_free()
	
func pause():
	timer.stop()
	
func set_host(who):
	host = who
	
func get_index():
	return current.index
	
##############
	
func enter():
	pass
	
func constant(delta):
	pass
	
func tick():
	pass
	
func undo():
	pass
