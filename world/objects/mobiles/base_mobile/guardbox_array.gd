extends Spatial

signal blocked
signal parried

var delay_timer: = Timer.new()
var delay: float = 0.15
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
	
	
func parry(dir:String) -> void:
	get_node(dir).parry()
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
	if !incoming.has(theirbox) and theirbox.state == Hitbox.states.STRIKE:
		incoming[theirbox] = mybox
		print(theirbox.name, " struck ", mybox.name)
		delay_timer.start(delay)
	
	
func on_delay_timer() -> void:
	if !incoming.empty():
		if incoming.values().front().state == Hitbox.states.GUARD:
			emit_signal("blocked", incoming.values().front(), incoming.keys().front())
		elif incoming.values().front().state == Hitbox.states.PARRY:
			emit_signal("parried", incoming.values().front(), incoming.keys().front())
	incoming.clear()
	
	
func get_collisions():
	return incoming
	
