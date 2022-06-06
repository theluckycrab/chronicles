extends BaseMobile

var stagger = preload("res://world/objects/mobiles/player/PlayerStates/player_state_stagger.gd").new()
var attack = preload("res://world/objects/mobiles/target_dummy/light_attack.gd").new()

func _init() -> void:
	index = "target_dummy"

func _ready():
	net_stats.register()
	armature.connect("blocked", self, "on_blocked")
	armature.guard("Left")
	stagger.host = self
	attack.host = self
	add_child(stagger)
	add_child(attack)
	$Hitbox.idle()
	$Hitbox.connect("hitbox_entered", self, "on_got_hit")
	at_war = true
	set_default("Head", "wizard_hat")
	set_default("Mainhand", "scimitar")
	var defaults = get_defaults_dict()
	for i in defaults:
		equip(defaults[i])
	
	
func _physics_process(delta):
	if lock_target and self.can_act and state_machine.get_state() != attack:
		action()
	

func on_blocked():
	set_state(stagger)

func on_got_hit(mybox, theirbox):
	print(theirbox.damage.tags)
	
func action():
	set_state(attack)
