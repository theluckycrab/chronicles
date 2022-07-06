extends Control

var item_list = []
var active = false setget set_active
var has_cycled = false

func _ready():
	if item_list.empty():
		return
	$ItemIcon.refresh(item_list.front())
	

func _physics_process(_delta):
	if !active:
		return
	if Input.is_action_just_pressed("ui_left"):
		cycle("left")
	elif Input.is_action_just_pressed("ui_right"):
		cycle("right")
		
func cycle(dir):
	if item_list.empty():
		return
	has_cycled = true
	$ItemIcon/Decorations/Destroy.visible = false
	match dir:
		"left":
			var i = item_list.pop_back()
			item_list.insert(0, i)
		"right":
			var i = item_list.pop_front()
			item_list.append(i)
	$ItemIcon.refresh(item_list[0])
	
func set_active(a):
	active = a
	if a == true:
		$ItemIcon/Decorations.show()
		$ItemIcon/Label.show()
	else:
		has_cycled = false
		$ItemIcon/Decorations.hide()
		$ItemIcon/Label.hide()

func refresh(item):
	$ItemIcon.refresh(item.index)
	
func set_item(item:Item):
	$ItemIcon.refresh(item.index)

func set_list(list):
	var l = []
	for i in list:
		if i.get_slot() == name:
			l.append(i)
	item_list = l
	if item_list.empty():
		$ItemIcon/Label.text = "No Items"

func get_item():
	if item_list.empty():
		return null
	return item_list[0]
