extends KinematicBody
class_name BaseProjectile

var velocity = Vector3.ZERO
var speed = 10

func _ready():
	$Hitbox.connect("hit", self, "on_hit")

func _physics_process(delta):
	move(delta)

func move(delta):
	var _discard = move_and_slide(velocity * speed)

func set_damage_profile(d:DamageProfile):
	$Hitbox.damage_profile = d

func get_damage_profile():
	return $Hitbox.damage_profile

func as_dict() -> Dictionary:
	var dict = {}
	dict["category"] = "projectile"
	dict["speed"] = speed
	dict["damage_profile"] = get_damage_profile().as_dict().duplicate(true)
	return dict
	
func build_from_dictionary(dict):
	if dict.has("damage_profile"):
		set_damage_profile(DamageProfile.new(dict.damage_profile))
	pass

func on_hit():
	$Hitbox.reset()
