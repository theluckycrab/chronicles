extends KinematicBody

var speed
var damages = {}
var target_dir = Vector3.BACK

func set_speed(s):
	speed = s
	
func set_size(s):
	$CollisionShape.get_shape().height *= s

func set_damages(d):
	damages = d
	
func set_facing(r):
	rotation.y = r
	target_dir = target_dir.rotated(Vector3.UP, r)
	
func _ready():
	print(damages)
			
func _physics_process(delta):
	#print(target_dir)
	move_and_collide(target_dir * speed)
		
