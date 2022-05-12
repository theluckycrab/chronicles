extends Spatial

export(String) var item = "debug_item"

onready var mesh = $KinematicBody/MeshInstance
onready var body = $KinematicBody
onready var shape = $KinematicBody/CollisionShape.get_shape()


func _ready() -> void:
	item = Data.reference.get_instance(item)
	mesh.mesh = load(item.visual.mesh_file_path)
	var mpos = mesh.mesh.get_aabb()
	mpos = mpos.position + (mpos.size / 2)
	$KinematicBody/CollisionShape.transform.origin = mpos
	shape.extents = mesh.mesh.get_aabb().size / 2
