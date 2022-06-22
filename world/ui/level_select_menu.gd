extends Control


func _ready():
	connect("visibility_changed", self, "on_visibility_changed")
	for i in Data.reference.scene_list.keys():
		if "menu" in i:
			pass
		else:
			var b = Button.new()
			b.text = i
			$Panel/VBoxContainer.add_child(b)
			b.connect("button_down", self, "on_button_down", [b.text])
		
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		hide()
		
func on_button_down(t):
	if t == Network.map:
		hide()
		return
	else:
		Events.emit_signal("scene_change_request", t)
	
func on_visibility_changed():
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
