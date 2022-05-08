extends Control

export var items = ["a", "b", "c", "d", "e", "f", "g"]
export var radius = 150

func _ready():
	var pos = get_rect().size / 2
	var up = Vector2.UP
	var turn = deg2rad(360/items.size())
	up = up.rotated(-turn)
	var count = 0
	for i in items:
		up = up.rotated(turn)
		var lab = Label.new()
		add_child(lab)
		lab.rect_position = pos + up * radius
		lab.text = i
	$Indicator.rect_position = pos + Vector2.UP * radius - $Indicator.rect_pivot_offset
		
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_right"):
		$TextureRect.set_rotation($TextureRect.get_rotation() + deg2rad(360/items.size()))
		shift("right")
	elif Input.is_action_just_pressed("ui_left"):
		$TextureRect.set_rotation($TextureRect.get_rotation() - deg2rad(360/items.size()))
		shift("left")
	elif Input.is_action_just_pressed("ui_accept"):
		print(items[0])
		
func shift(dir):
	if dir == "right":
		var n = items.front()
		items.pop_front()
		items.append(n)
	elif dir == "left":
		var n = items.back()
		items.pop_back()
		items.insert(0, n)
	for i in get_children():
		if i is Label:
			i.queue_free()
	_ready()
