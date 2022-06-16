extends MeshInstance

func activate(_host):
	var object = Data.get_reference_instance("target_dummy")
	add_child(object)
	object.global_transform.origin = Vector3(0,5,0)
