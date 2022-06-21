extends Spatial
export(String) var animation = "Sit_Floor"
export(String) var action = "Interact"

onready var action_label = $Label

func _ready():
	$PickupZone.connect("body_entered", self, "on_body_entered")
	$PickupZone.connect("body_exited", self, "on_body_exited")
	action_label.text = "Press E to " + action.to_lower()

func activate(host):
	host.state_machine.get_state("emote").animation = animation
	host.set_state("emote")
	yield(get_tree().create_timer(0.02), "timeout")
	rot(host)
	$Label.visible = false

func rot(host):
	host.armature.global_transform.origin = global_transform.origin
	host.armature.rotation.y = atan2(global_transform.basis.z.x, global_transform.basis.z.z)

func on_body_entered(body):
	if body is BaseMobile:
		if body.net_stats.netID == Network.get_nid():
			$Label.visible = true

func on_body_exited(body):
	if body is BaseMobile:
		if body.net_stats.netID == Network.get_nid():
			$Label.visible = false
