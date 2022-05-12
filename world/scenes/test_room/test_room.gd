extends Spatial


func _ready() -> void:
	var _discard = Events.connect("spawn", self, "on_spawn")
	
	
func on_spawn(args) -> void:
	spawn(args.parent, args.index, args.position, args.modifications)


func spawn(parent, index, position, modification) -> void:
	var wobject = load("res://world/objects/generic/world_object.tscn").instance()
	wobject.item = index
	add_child(wobject)
	wobject.global_transform.origin = position
