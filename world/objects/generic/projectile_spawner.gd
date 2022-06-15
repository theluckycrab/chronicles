extends Spawner

func retrieve_data(index:String):
	return Data.get_projectile(index).instance()
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("debug"):
		spawn()
