extends Spatial

var rotation_speed = 15
onready var anim = $AnimationPlayer

func face_dir(wasd, delta):
	var a = atan2(wasd.x, wasd.z)
	rotation.y = lerp_angle(rotation.y, a, rotation_speed * delta)

func play(animation, motion: bool = false):
	if motion:
		anim.stop()
		anim.play_with_root_motion(animation)
	else:
		anim.tree.active = false
		anim.play(animation)
	anim.last_animation = animation

func equip(args):
	var m = MeshInstance.new()
	var item = Data.get_item(args.base_item)
	for i in args:
		if item.current.has(i):
			item.current[i] = args[i]
	$base_human/Armature/Skeleton.add_child(m)
	m.mesh = load("res://blender/equipment/"+item.current.mesh+".mesh")
	m.skeleton = $base_human/Armature/Skeleton.get_path()
