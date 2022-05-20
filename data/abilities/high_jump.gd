extends Ability


func execute(_item: Item, host: Object) -> void:
	print("high jump")
	host.add_force(Vector3.UP * 400)
	yield(host.get_tree().create_timer(1), "timeout")
