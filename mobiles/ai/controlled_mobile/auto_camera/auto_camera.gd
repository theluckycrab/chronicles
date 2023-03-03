extends Camera

var host
var tracking = false

func _ready():
	get_parent().remove_child(self)

func _process(delta):
	if ! is_instance_valid(host.lock_target):
		return
	rotate_to_fit(delta)
	scale_view(delta)

func is_on_screen(unit):
	var view_size = Vector2(200, 200)
	var min_limit = (get_viewport().size / 2) - view_size
	var max_limit = (get_viewport().size)
	var screenpos = unproject_position(unit.global_transform.origin)
	if screenpos.x > min_limit.x \
			and screenpos.y > min_limit.y \
			and !get_viewport().get_camera().is_position_behind(unit.global_transform.origin) \
			and screenpos.x < max_limit.x \
			and screenpos.y < max_limit.y:
		return true
	else:
		return false
		
func get_midpoint():
	var hpos = host.global_transform.origin
	var tpos = host.lock_target.global_transform.origin
	var midpos = ((tpos - hpos) / 2) + hpos
	midpos.y = hpos.y
	return midpos

func scale_view(delta):
	var offset = Vector3(0, 2, 6)
	var dist = host.distance_to(host.lock_target)
	offset += Vector3(0,0,0.5) * dist
	offset = offset.rotated(Vector3.UP, rotation.y)
	global_transform.origin = global_transform.origin.linear_interpolate(get_midpoint() + offset, 2 * delta)

func screen_log(s):
	$RichTextLabel.text = str(s) + "\n+"

func rotate_to_fit(delta):
	var onscreen = is_on_screen(host) as int + is_on_screen(host.lock_target) as int
	if ! onscreen:
		fov = lerp(fov, fov + 2, 0.05)
	else:
		fov = lerp(fov, fov - 2, 0.05)
	fov = clamp(fov, 60, 90)
	var dir = get_midpoint()
	var angle = atan2(dir.x, dir.z) / 2
	rotation.y = lerp_angle(rotation.y, angle, delta)
