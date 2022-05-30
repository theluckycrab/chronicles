extends Spatial

var delay_timer = Timer.new()
var delay = 1
var incoming = {}
onready var indicator = $Indicator

func _ready():
	delay_timer.one_shot = true
	delay_timer.autostart = false
	add_child(delay_timer)
	delay_timer.connect("timeout", self, "on_delay_timer")
	hook_up_children()
	indicator.visible = false

func guard(dir):
	get_node(dir).guard()
	indicator.visible = true
	indicator.global_transform.origin = get_node(dir).get_child(0).global_transform.origin
	pass
	
func reset(dir = "all"):
	if dir == "all":
		for i in get_children():
			if i is Hitbox:
				i.reset()
	else:
		get_node(dir).ghost()
	indicator.visible = false
	pass
	
func hook_up_children():
	for i in get_children():
		if i is Hitbox:
			i.connect("hitbox_entered", self, "on_hitbox_entered")
			i.ghost()
			i.set_owner(get_parent().get_parent())
		
func on_hitbox_entered(mybox, theirbox):
	if !incoming.has(theirbox):
		incoming[theirbox] = mybox
		delay_timer.start(delay)
	print(mybox, " hit by ", theirbox)
	pass
	
func on_delay_timer():
	print(incoming)
	incoming.clear()
	
