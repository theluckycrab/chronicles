extends AnimationPlayer

var override_list = {
}

func _ready():
	connect("animation_started", self, "on_animation_started")
	
func on_animation_started(anim):
	if anim in override_list:
		play(override_list[anim])
