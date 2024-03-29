extends State

var lat_acceleration: float = 0.33
var base_lat: float = 15
var lateral_speed: float = base_lat
var max_lat: float = 30

var enter_y: float = 0
var jumped: bool = false

var max_height: float = 2
var actual_time: float = 0.33#0.33
var frame_height: float = max_height / actual_time

func _init():
	priority = 3
	index = "Jump"
	
func _physics_process(_delta):
	if jumped == true and host.is_on_floor():
		jumped = false 

func can_enter() -> bool:
	return jumped == false
	
func can_exit() -> bool:
	return host.is_on_ceiling() \
		or host.global_transform.origin.y > enter_y + max_height

func enter() -> void:
	enter_y = host.global_transform.origin.y
	lateral_speed = base_lat
	
func exit() -> void:
	pass
	
func execute() -> void:
	var wasd: Vector3 = host.ai.get_wasd_cam()
	host.set_velocity(wasd * lateral_speed)
	host.add_force(Vector3.UP * frame_height)
	host.add_force(Vector3.UP * 8)
	
	lateral_speed += lat_acceleration
	lateral_speed = clamp(lateral_speed, 0, max_lat)
	
	host.play("Jump")
	jumped = true
