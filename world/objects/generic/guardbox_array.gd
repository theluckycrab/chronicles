extends Spatial

var delay_timer: = Timer.new()
var delay: float = 1
var incoming: Dictionary = {}

onready var indicator = $Indicator


func _ready() -> void:
	delay_timer.one_shot = true
	delay_timer.autostart = false
	add_child(delay_timer)
	var _discard = delay_timer.connect("timeout", self, "on_delay_timer")
	hook_up_children()
	indicator.visible = false


func guard(dir:String) -> void:
	get_node(dir).guard()
	indicator.visible = true
	indicator.global_transform.origin = get_node(dir).get_child(0).global_transform.origin
	
	
func reset(dir: String = "all") -> void:
	if dir == "all":
		for i in get_children():
			if i is Hitbox:
				i.reset()
	else:
		get_node(dir).ghost()
	indicator.visible = false
	
	
func hook_up_children() -> void:
	for i in get_children():
		if i is Hitbox:
			i.connect("hitbox_entered", self, "on_hitbox_entered")
			i.ghost()
			i.set_owner(get_parent().get_parent())
	
	
func on_hitbox_entered(mybox, theirbox) -> void:
	if !incoming.has(theirbox):
		incoming[theirbox] = mybox
		delay_timer.start(delay)
	print(mybox, " hit by ", theirbox)
	
	
func on_delay_timer() -> void:
	incoming.clear()
	
