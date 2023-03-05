extends Spatial
class_name Armature

var equipped_items: Dictionary = {}
var rotation_speed: float = 15
onready var animator: ArmatureAnimator = $ArmatureAnimator
onready var skeleton: Skeleton = $Skeleton
onready var sensors: Spatial = $Sensors


func equip(item: BaseItem) -> void:
	var new_mesh := MeshInstance.new()
	unequip(item.get_slot())
	equipped_items[item.get_slot()] = {"mesh":new_mesh, "item":item}
	skeleton.add_child(new_mesh)
	new_mesh.mesh = load("res://data/assets/3d/meshes/equipment/"+item.current.mesh+".mesh")
	new_mesh.skeleton = skeleton.get_path()
	var anims = item.get_animation_overrides()
	for i in anims:
		animator.add_animation_override(i, anims[i])
	
func face_dir(wasd: Vector3, delta: float) -> void:
	if wasd == Vector3.ZERO:
		return
	var a = atan2(wasd.x, wasd.z)
	rotation.y = lerp_angle(rotation.y, a, rotation_speed * delta)

func get_current_animation() -> String:
	return animator.get_current_animation()
	
func get_root_motion() -> Transform:
	return animator.get_root_motion()
	
func is_using_root_motion() -> bool:
	return animator.is_using_root_motion()

func play(animation: String, motion: bool = false):
	animator.play_animation(animation, motion)

func unequip(slot: String) -> void:
	if equipped_items.has(slot) and is_instance_valid(equipped_items[slot].item):
		for i in equipped_items[slot].item.get_animation_overrides():
			animator.remove_animation_override(i)
		equipped_items[slot].mesh.queue_free()
	var _discard = equipped_items.erase(slot)

func get_ledge() -> Vector3:
	return sensors.get_ledge()

func get_interact_target() -> Spatial:
	return sensors.get_interact_target()
