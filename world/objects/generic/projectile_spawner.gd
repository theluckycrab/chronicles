extends Spawner

func retrieve_data(index:String):
	return Data.get_projectile(index).instance()
