extends KinematicBody
class_name BaseProjectile

var velocity = Vector3.ZERO
var speed = 100
var current = {}

func _ready():
	$Hitbox.connect("hit", self, "on_hit")

func set_damage_profile(d:DamageProfile):
	current["damage_profile"] = d
	$Hitbox.damage_profile = d

func get_damage_profile():
	return $Hitbox.damage_profile

func as_dict() -> Dictionary:
	var dict = current.duplicate(true)
	dict["category"] = "projectile"
	dict["speed"] = speed
	dict["damage_profile"] = get_damage_profile().as_dict().duplicate(true)
	return dict
	
func build_from_dictionary(dict):
	current = dict.duplicate(true)
	if current.has("damage_profile"):
		set_damage_profile(DamageProfile.new(current.damage_profile))
	if current.has("pattern"):
		match current.pattern:
			"ray":
				velocity = Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
	pass

func on_hit():
	$Hitbox.reset()

func set_source(s):
	current.damage_profile.set_source(s)

func sync_move(args):
	global_transform.origin = args.position
	rotation.y = args.rotation
	
