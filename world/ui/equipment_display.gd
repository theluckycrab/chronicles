extends Control

export(NodePath) onready var host = get_node(host)
var active: bool = false
var slot_list = ["Head", "Boots", "Offhand", "Mainhand", "Consumable"]
var current_equipment = {}
var active_icon = null

func _physics_process(_delta):
	controls()

func _ready():
	host.connect("equipped_item", self, "on_equipped_item")
	close()
	
func on_equipped_item(item):
	current_equipment[item.get_slot()] = item
	if get_node_or_null(item.get_slot().capitalize()) != null:
		get_node(item.get_slot().capitalize()).set_item(item)
	call_deferred("close")
	
func close():
	for i in slot_list:
		var n = get_node_or_null(i)
		if n != null:
			if current_equipment.has(i.to_lower()):
				n.set_item(current_equipment[i.to_lower()])
			n.active = false
			n.show()
	active = false
	active_icon = null
			
func activate_icon(slot):
	for i in slot_list:
		var n = get_node_or_null(i)
		if n != null and n.has_method("set_active"):
			n.set_active(false)
			#n.hide()
	var s = get_node_or_null(slot)
	if slot == null:
		return
	if s.has_method("set_active"):
		s.active = true
		s.set_list(host.inventory.get_item_list())
		s.show()
		active_icon = s

func activate_item():
	if active_icon == null:
		return
	var item = active_icon.get_item()
	if item == null:
		return
	if "Consumable" in active_icon.name:
		host.set_state(item.active)
	else:
		host.equip(item)

func controls():
	if !active:
		if Input.is_action_just_pressed("item_mod"):
			active = true
			activate_icon("Consumable")
			active_icon.cycle("right")
			return
		for i in slot_list:
			if host.can_act and i != "Consumable" and Input.is_action_pressed("ability_mod"):
				if Input.is_action_just_pressed(i.to_lower()):
					host.activate_item_slot(i.to_lower())
		return
	if active:
		if Input.is_action_just_released("item_mod"):
			active = false
			close()
			return
		for i in slot_list:
			if Input.is_action_just_pressed(i.to_lower()):
				if active_icon.name == i:
					active_icon.cycle("right")
				else:
					if is_instance_valid(active_icon) and current_equipment.has(active_icon.name):
						active_icon.refresh(current_equipment[active_icon.name])
					activate_icon(i)
		if Input.is_action_just_pressed("guard"):
			if active_icon != null:
				if active_icon.has_cycled or active_icon.name == "Consumable":
					activate_item()
				else:
					host.destroy(active_icon.name)
