extends KinematicBody

const GRAVITY = 9
var velocity = Vector3.ZERO
onready var anim = $Armature/AnimationPlayer

func _physics_process(_delta) -> void:
	if !is_on_floor():
		anim.play("Fall")
		velocity = Vector3.DOWN * GRAVITY
	else:
		anim.play("Idle")
	move()
		
		
func move():
	var balls = move_and_slide_with_snap(velocity, Vector3.DOWN, Vector3.UP)
