extends Spatial

signal activated

export(String) var animation = "Sit_Floor"
export(String) var action = "Interact"

func _ready():
	$InteractableZone.set_action_label(action)
	$InteractableZone.connect("exited", self, "on_exited")

func activate(host):
	host.state_machine.get_state("emote").animation = animation
	host.set_state("emote")
	host.global_transform.origin = global_transform.origin
	yield(get_tree().create_timer(0.02), "timeout")
	rot(host)
	emit_signal("activated", host)

func rot(host):
	host.armature.global_transform.origin = global_transform.origin
	host.armature.rotation.y = atan2(global_transform.basis.z.x, global_transform.basis.z.z)

func on_exited(host):
	host.armature.global_transform.origin = host.global_transform.origin
