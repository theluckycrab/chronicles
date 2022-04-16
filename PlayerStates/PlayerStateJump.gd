extends Spatial
class_name PlayerStateJump

var animation = "Fall"
var priority = 1
var host = null
var slot = "Jump"

var duration = 0.25
var height = 3 / duration
var distance = 1.5 / duration
var done = false

onready var jumpTimer = Timer.new()

func _ready():
	add_child(jumpTimer)
	jumpTimer.autostart = false
	jumpTimer.one_shot = true
	jumpTimer.connect("timeout", self, "_on_jumpTimer")

func Controls():
	pass
	
func Enter():
	jumpTimer.start(duration)
	host.gravity.active = false
	pass
	
func Exit():
	host.gravity.active = true
	done = false
	pass
	
func canExit():
	return done
	
func canEnter():
	return host.is_on_floor()
	
func Execute():
	host.Add_Force((Vector3.UP * height) + (host.get_node("Armature").global_transform.basis.z * distance))
	pass
	
func _on_jumpTimer():
	done = true
