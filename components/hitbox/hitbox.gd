extends Area
class_name Hitbox

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
	setup()

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
	collision_stack.clear()
	
func strike(damage = DamageProfile.new()) -> void:
	collision_stack.clear()
	damage_profile = damage
	state = STATES.STRIKE
	force_update_transform()
	for i in get_overlapping_areas():
		on_area_entered(i)
	
func on_area_entered(area:Area) -> void:
	if state == STATES.GHOST or area.state == STATES.GHOST or area.state == STATES.STRIKE or collision_stack.has(area):
		return
	match state:
		STATES.STRIKE:
			if !damage_profile.has("multihit") and !collision_stack.empty():
				return
			touched(area)
			area.touched(self)
		
func emit_hit(dp : DamageProfile) -> void:
	match state:
		STATES.IDLE:
			emit_signal("got_hit", dp)
		STATES.STRIKE:
			emit_signal("hit")
	
func get_damage_profile() -> DamageProfile:
	return damage_profile

func set_damage_profile(dp: DamageProfile) -> void:
	damage_profile = dp

func touched(area):
	collision_stack.append(area)
	emit_hit(area.get_damage_profile())
