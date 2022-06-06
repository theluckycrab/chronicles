extends BaseMobile

var stagger = preload("res://world/objects/mobiles/player/PlayerStates/player_state_stagger.gd").new()

func _init() -> void:
	index = "target_dummy"

func _ready():
	armature.connect("blocked", self, "on_blocked")
	armature.guard("Left")
	stagger.host = self
	add_child(stagger)
	$Hitbox.idle()
	$Hitbox.connect("hitbox_entered", self, "on_got_hit")
	

func on_blocked():
	set_state(stagger)

func on_got_hit(mybox, theirbox):
	print(theirbox.damage.tags)
