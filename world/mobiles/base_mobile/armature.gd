class_name Armature
extends Spatial

signal blocked
signal hit
signal got_parried
signal parried
signal got_blocked

onready var equipment: Dictionary
onready var host = get_parent()
onready var anim = $AnimationPlayer
onready var weaponbox = $Skeleton/Mainhand/Weapon/MeshInstance/Hitbox
onready var guardbox = $Guardbox
onready var overhead_chat = $OverheadChat
onready var overhead_system = $OverheadSystem
onready var weapon = $Skeleton/Mainhand/Weapon/MeshInstance
onready var sheath = $Skeleton/Sheath/Sheath/MeshInstance
onready var body = $Skeleton/Body
onready var hit_origin = $HitOrigin

func _ready():
	for i in $Guardbox.get_children():
		if i.has_method("Connect"):
			i.Connect(self)
	weaponbox.Connect(self)
	overhead_system.set_color(Data.get_config_value("system_color"))
	hide_weapon()
	if body is PhaseMesh:
		body.phase()
	

func destroy(slot: String) -> void:
	var mount = get_node_or_null("Skeleton/"+slot)
	if slot == "Mainhand":
		mount = get_node_or_null("Skeleton/"+slot+"/Weapon/MeshInstance")
	if mount:
		mount.set_mesh(null)
		


func equip(args:Dictionary) -> void:
	var item = Data.get_item(args.index)
	var slot = item.get_slot().capitalize()
	var mount = get_node_or_null("Skeleton/"+slot)
	if slot == "Mainhand":
		mount = get_node_or_null("Skeleton/"+slot+"/Weapon/MeshInstance")
	if mount:
		mount.set_mesh(item.get_mesh())
		if slot == "Mainhand":
			sheath.set_mesh(item.get_mesh())
			if host is BaseMobile:
				size_weapon()
				if host.at_war:
					show_weapon()
				else:
					sheath.phase()
					hide_weapon()
	equipment[item.get_slot()] = args.index
	if mount is PhaseMesh:
		mount.phase()

func face(dir:Vector3) -> void:
	if dir == Vector3.ZERO:
		return
		
	var angle = atan2(dir.x, dir.z)
	rotation.y = lerp_angle(rotation.y, angle, 0.2)


func play(animation, motion: bool = false) -> void:
	if motion:
		anim.stop()
		anim.play_with_root_motion(animation)
	else:
		anim.tree.active = false
		anim.play(animation)
	anim.last_animation = animation
	

func get_root_motion():
	return anim.get_root_motion()
	
	
func get_animation() -> String:
	if anim.is_playing():
		return anim.current_animation
	elif anim.tree.active:
		if !anim.tree.get("parameters/OneShot/active"):
			return ""
		return anim.tree.get_tree_root().get_node("Action").animation
	else:
		return ""
	
	
func guard(dir:String) -> void:
	guardbox.guard(dir)
	
	
func parry(dir:String) -> void:
	guardbox.parry(dir)
	
	
func guard_reset() -> void:
	guardbox.reset()
	
	
func size_weapon() -> void:
	var mesh = weapon
	var box = weaponbox.get_node_or_null("CollisionShape")
	var length = mesh.get_aabb().size
	var pos = mesh.get_aabb().position
	if box == null:
		return
	if length == Vector3.ZERO:
		length = Vector3(0.1, 0.4, 0.1)
	if pos == Vector3.ZERO:
		pos = Vector3(0.1, 0.1, -0.1)
	box.transform.origin = pos + length / 2
	box.get_shape().set_extents(length / 2)


func get_hit_origin() -> Vector3:
	return hit_origin.global_transform.origin


func weaponbox_strike() -> void:
	weaponbox.strike()
	#keyframe()
	
	
func weaponbox_damage(damage) -> void:
	weaponbox.damage = damage
	
	
func weaponbox_ghost() -> void:
	weaponbox.ghost()


func is_using_root_motion() -> bool:
	return anim.is_using_root_motion()


func on_got_blocked(theirbox):
	emit_signal("got_blocked", theirbox)
	
func on_blocked(theirbox):
	emit_signal("blocked", theirbox)
	
func on_hit(theirbox):
	emit_signal("hit", theirbox)
	
func on_got_parried(theirbox):
	emit_signal("got_parried", theirbox)
	
func on_parried(theirbox):
	emit_signal("parried", theirbox)
	
func on_clash_lost(theirbox):
	print(theirbox, " clashed and won")


func hide_weapon() -> void:
	weapon.visible = false
	sheath.visible = true
	
	
func show_weapon() -> void:
	weapon.visible = true
	sheath.visible = false


func keyframe() -> void:
	anim.emit_signal("keyframe")


func print_overhead_chat(args):
	if args.has("color"):
		overhead_chat.set_color(args.color as Color)
	var split = args.text.split(":")
	if split.size() != 0:
		split.remove(0)
	split = split.join(" ")
	overhead_chat.lifespan = 3 + split.length() * 0.1
	overhead_chat.text += split + "\n"
	

func print_overhead_system(text):
	overhead_system.text += text + "\n"
	
