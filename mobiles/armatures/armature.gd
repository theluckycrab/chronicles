extends Spatial
class_name Armature

"""
	The Armature is the visual representation of a character in the world. It handles rotation, 
		animation, root motion, and sensors that need to rotate with the character. It is named
		"Armature" to play nicely when animating skeletons and meshes that are saved from
		blender-exported .glb files.
		
	Dependencies : ArmatureAnimator, "res://data/assets/3d/meshes/equipment/"
	Setup : Do not use the base Armature scene. Inherit it instead.
			- ArmatureAnimator
				- Add animations manually
			- Skeleton
				- Mesh that is mapped to the skeleton
"""

var equipped_items: Dictionary = {}
var rotation_speed: float = 15
onready var animator: ArmatureAnimator = $ArmatureAnimator
onready var skeleton: Skeleton = $Skeleton


func equip(item: BaseItem) -> void:
	var new_mesh := MeshInstance.new()
	unequip(item.current.slot)
	equipped_items[item.current.slot] = new_mesh
	skeleton.add_child(new_mesh)
	new_mesh.mesh = load("res://data/assets/3d/meshes/equipment/"+item.current.mesh+".mesh")
	new_mesh.skeleton = skeleton.get_path()
	
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
	if equipped_items.has(slot) and is_instance_valid(equipped_items[slot]):
		equipped_items[slot].queue_free()

