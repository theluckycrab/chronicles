extends AnimationPlayer

var override_list = {
}


func _ready() -> void:
	var _discard = connect("animation_started", self, "on_animation_started")
	
	
func on_animation_started(anim:String) -> void:
	if anim in override_list:
		play(override_list[anim])
