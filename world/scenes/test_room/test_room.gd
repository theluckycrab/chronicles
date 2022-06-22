extends Spatial

var spawn_count = 0
var max_enemies = 5
var spawn_timer = Timer.new()
onready var mon_mount = Spatial.new()

func _ready() -> void:
	var _discard = Events.connect("spawn", self, "on_spawn")
	var object = Data.get_reference_instance("player")
	call_deferred("add_child", object)
	add_child(spawn_timer)
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	spawn_timer.wait_time = 10
	spawn_timer.connect("timeout", self, "on_spawn_timer")
	spawn_timer.start()
	add_child(mon_mount)
	
func on_spawn(object, position = Vector3(0, 5, 0)) -> void:
	add_child(object)
	object.global_transform.origin = position


func on_spawn_timer():
	if Network.get_map_master("test_room", Network.get_nid()) != Network.get_nid():
		return
	if spawn_count < max_enemies:
		var object = Data.get_reference_instance("target_dummy")
		mon_mount.add_child(object)
		mon_mount.add_child(Data.get_reference_instance("target_dummy"))
	spawn_count = mon_mount.get_child_count()
