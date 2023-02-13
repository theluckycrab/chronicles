extends Area
class_name Hitbox

"""
	Hitboxes are areas that are used to detect combat collisions. Each hitbox may be in one of three
		states. Ghost state ignores all collisions. Idle state is prepared to get hit. Strike state
		is ready to hit an Idle state. Upon collision, the hit_data dictionary is sent to the other
		party and the appropriate signal is emitted. The owner of the hitbox must decide what to do
		with the hit_data dictionary and the signal. Assume that the other party was deleted instantly
		upon collision.
		
	Dependencies : 
	Setup : A collision layer for hitboxen should be defined in the Project Settings.
			The collision shape of the Hitbox scene should be set as local to scene
"""

const HITBOX_LAYER: int = 2
enum STATES {GHOST, IDLE, STRIKE}

signal hit
signal got_hit

var hit_data: Dictionary = {}
export(STATES) var state: int = STATES.GHOST

func _ready() -> void:
	var _discard = connect("area_entered", self, "on_area_entered")
	collision_layer = 2
	collision_mask = 2

func setup() -> void:
	collision_layer = HITBOX_LAYER
	collision_mask = HITBOX_LAYER
	
func ghost() -> void:
	state = STATES.GHOST
	
func idle() -> void:
	state = STATES.IDLE
	
func strike() -> void:
	state = STATES.STRIKE
	
func on_area_entered(area:Area) -> void:
	if state == STATES.GHOST or area.state == STATES.GHOST or state == area.state:
		return
	elif area.has_method("get_hit_data"):
		emit_hit(area.get_hit_data())
		
func emit_hit(h_data: Dictionary) -> void:
	match state:
		STATES.IDLE:
			emit_signal("got_hit", h_data)
		STATES.STRIKE:
			emit_signal("hit", h_data)
	
func get_hit_data() -> Dictionary:
	return hit_data
