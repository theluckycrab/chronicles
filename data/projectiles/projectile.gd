extends KinematicBody
class_name Projectile

var despawn_timer = Timer.new()
var despawn_delay = 0.2
var source = null
var damage = null setget set_damage, get_damage

func _ready():
	setup_despawn_timer()
	

func setup_despawn_timer():
	despawn_timer.autostart = true
	despawn_timer.one_shot = true
	add_child(despawn_timer)
	despawn_timer.connect("timeout", self, "on_despawn")
	despawn_timer.start(despawn_delay)
	
	
func on_despawn():
	queue_free()
	

func set_damage(dam):
	$Hitbox.damage = dam
	
func get_damage():
	return $Hitbox.damage
