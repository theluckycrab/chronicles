extends Area
class_name Hitbox

signal hit
var damage = {"dongetto":1, "alabaster":5, "aoe":5}
enum states { GHOST, IDLE, STRIKE }
export var state: = states.GHOST
onready var host = owner

func _ready():
	var _d = connect("area_entered", self, "on_area_entered")
	force_update()

func on_area_entered(other):
	if other.has_method("is_hitbox") and other.state == states.STRIKE:
		emit_signal("hit", other.get_damage())
	
func get_damage():
	return {"damages":damage.duplicate(true)}

func force_update():
	for i in get_overlapping_areas():
		on_area_entered(i)

func is_hitbox():
	return true
