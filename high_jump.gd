extends Ability

func execute(host) -> void:
	#var item = host.equip_item(self)
	host.add_force(Vector3.UP * 400)
	yield(host.get_tree().create_timer(1), "timeout")
	#item.queue_free()
