extends State

var lat_acceleration = 0.33
var base_lat = 15
var lateral_speed = base_lat
var max_lat = 30

var enter_y = 0
var jumped = false

var max_height = 2
var actual_time = 0.33
var frame_height = max_height / actual_time

func _init():
	priority = 1
	index = "Jump"
	
func _physics_process(_delta):
	if jumped == true and (host.is_on_floor() \
	or (host.get_skill("mobility") > 0 and host.is_on_wall())):
		jumped = false

func can_enter():
	return jumped == false
	
func can_exit():
	return host.is_on_ceiling() \
		or host.global_transform.origin.y > enter_y + max_height #or Input.is_action_just_released("ui_accept")

func enter():
	enter_y = host.global_transform.origin.y
	lateral_speed = base_lat
	host.using_gravity = false
	jumped = true
	pass
	
func exit():
	host.using_gravity = true
	pass
	
func execute():
	var wasd = host.get_wasd_cam()
	host.set_velocity(wasd * lateral_speed)
	host.add_force(Vector3.UP * frame_height)
	
	lateral_speed += lat_acceleration
	lateral_speed = clamp(lateral_speed, 0, max_lat)
	
	host.play("Jump")
