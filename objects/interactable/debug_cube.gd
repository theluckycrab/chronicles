extends StaticBody

func interact(target) -> void:
	target.global_transform.origin = $Position3D.global_transform.origin

func _ready():
	$Hitbox.connect("got_hit", self, "on_got_hit")
	
func on_got_hit(damage_profile) -> void:
	if damage_profile.has("strong"):
		print("so strong!~~~")
	else:
		print("pathetic")
