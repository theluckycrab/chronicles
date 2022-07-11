extends BaseMobile

func _init():
	net_stats = NetStats.new("debug")
	
func _physics_process(_delta):
	parry({"direction":"Right"})

