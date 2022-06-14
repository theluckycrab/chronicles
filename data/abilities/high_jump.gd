extends Ability


func execute(_item: Item, host: Object) -> void:
	print("high jump")
	host.add_force(Vector3.UP * 400)
