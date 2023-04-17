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

var damage_profile: DamageProfile = DamageProfile.new()
var collision_stack = []
export(STATES) var state: int = STATES.GHOST
onready var start_state = state

func _ready() -> void:
	var _discard = connect("area_entered", self, "on_area_entered")
	collision_layer = 2
	collision_mask = 2

func setup() -> void:
	collision_layer = HITBOX_LAYER
	collision_mask = HITBOX_LAYER
	
func ghost() -> void:
	state = STATES.GHOST
	collision_stack.clear()
	
func idle() -> void:
	state = STATES.IDLE
	
func reset() -> void:
	state = start_state
	
func strike(damage = {}) -> void:
	damage_profile = DamageProfile.new(damage)
	state = STATES.STRIKE
	force_update_transform()
	for i in get_overlapping_areas():
		i.on_area_entered(self)
	
func on_area_entered(area:Area) -> void:
	if state == STATES.GHOST or area.state == STATES.GHOST or state == area.state:
		return
	elif area.has_method("get_damage_profile"):
		if collision_stack.has(area):
			return
		collision_stack.append(area)
		emit_hit(area.get_damage_profile())
	yield(get_tree().create_timer(0.5), "timeout")
	collision_stack.clear()
		
func emit_hit(dp : DamageProfile) -> void:
	match state:
		STATES.IDLE:
			emit_signal("got_hit", dp)
		STATES.STRIKE:
			if !damage_profile.has("multihit"):
				ghost()
			emit_signal("hit")
	
func get_damage_profile() -> DamageProfile:
	return damage_profile

func set_damage_profile(dp: DamageProfile) -> void:
	damage_profile = dp
