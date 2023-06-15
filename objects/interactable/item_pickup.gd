extends Interactable

func _ready():
	add_to_group("loot")

func build_from_dictionary(dict={}):
	if dict.has("item"):
		item = dict.item
	$MeshInstance.mesh = load("res://data/assets/3d/meshes/equipment/"+Data.get_item(item).as_dict().mesh+".mesh")
	var box = $MeshInstance.get_transformed_aabb()
	$MeshInstance.global_transform.origin.y = global_transform.origin.y - box.position.y
	$CollisionShape.shape.extents = box.size
		
func as_dict():
	var d = .as_dict()
	d["item"] = item
