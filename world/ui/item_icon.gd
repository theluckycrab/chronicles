extends Control

signal exited_inventory

var item = "naked_mainhand"
var tooltip_delay = 0.25
onready var detail = $CanvasLayer/Detail

func _ready() -> void:
	if item is String:
		item = Data.get_item(item)
	build(item)
	detail.refresh(item.index)
	detail.hide()
	$Label.text = item.item_name
	if ! is_connected("mouse_entered", self, "on_mouse_entered") \
			and ! is_connected("mouse_exited", self, "on_mouse_exited"):
		var _discard = connect("mouse_entered", self, "on_mouse_entered")
		var _dicks = connect("mouse_exited", self, "on_mouse_exited")
		$TooltipDelay.connect("timeout", self, "on_tooltip_timer")


func build(n_item:Item) -> void:
	item = n_item
	$Viewport/Preview.mesh = n_item.get_mesh()
	var a1 = $Viewport/Preview.mesh.get_aabb()
	$Viewport/Camera.global_transform.origin = Vector3(0, a1.position.y + (a1.size.y/2), 1)
	var s = a1.size
	if s.x > s.y:
		s = s.x
	elif s.y >= s.x:
		s = s.y
	if s > 0:
		$Viewport/Camera.size = s * 1.1
	
	
func refresh(i) -> void:
	item = i
	_ready()
	pass
	
func show_label():
	$Label.show()
	
func hide_label():
	$Label.hide()


func on_mouse_entered():
	$TooltipDelay.start(tooltip_delay)
	pass
	
func on_mouse_exited():
	$TooltipDelay.stop()
	detail.hide()
	pass
	
func on_tooltip_timer():
	detail.show()
	detail.rect_global_position = get_viewport().get_mouse_position()
	pass

func get_drag_data(position):
	var data = {"item":item, "source":self}
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = $Icon.texture
	drag_texture.rect_size = Vector2(40,40)
	var c = Control.new()
	c.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size
	set_drag_preview(c)
	return data

func can_drop_data(position, data):
	return true
