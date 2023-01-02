extends KinematicBody

var speed
var damages = {}
var despawn_time = 0.25
var spawn_delay = 0
var target_dir = Vector3.BACK

func set_speed(s):
	speed = s
	
func set_size_x(s):
	scale.x = s
	
func set_size_y(s):
	scale.y = s
	scale.z = s

func set_despawn_time(t):
	despawn_time = t

func set_damages(d):
	damages = d
	
func set_facing(r):
	rotation.y = r
	target_dir = target_dir.rotated(Vector3.UP, r)
	
func _ready():
	$Hitbox/CollisionShape2.disabled = false
	var _D = $Hitbox.connect("hit", self, "on_hitbox")
	queue_free()
			
func _physics_process(_delta):
	var _d = move_and_collide(target_dir * speed)
		
func on_hitbox(_damage):
	queue_free()
