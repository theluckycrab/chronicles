extends KinematicBody

var velocity = Vector3.ZERO
var force = Vector3.ZERO
var using_gravity = true
var stored_delta = 0
var items
var attacking = false
var blocking = false

onready var state_machine = $StateMachine
onready var armature = $Armature

onready var jump_state = $StateMachine/Jump
	
func _ready():
	state_machine.connect("state_changed", $StateLabel, "set_text")
	yield(get_tree().create_timer(1), "timeout")
	if is_dummy():
		$CameraPivot/Vertical/Camera.current = false
	else:
		$CameraPivot/Vertical/Camera.current = true
	items = Data.get_item("thief_shoes")
	$Armature/Hitbox.connect("hit", self, "take_damage")
	
func _physics_process(delta):
	if !is_dummy():
		stored_delta = delta
		state_machine.cycle()
		if Input.is_action_just_pressed("jump"):
			state_machine.call_deferred("set_state", jump_state)
		if Input.is_action_just_pressed("ui_left"):
			equip({"base_item":items.current.index})
		if Input.is_action_just_pressed("left_click"):
			set_state("LightAttack")
		move(delta)

func get_wasd():
	var wasd = Vector3.ZERO
	wasd.x = Input.get_action_strength("a") - Input.get_action_strength("d")
	wasd.z = Input.get_action_strength("w") - Input.get_action_strength("s")
	return wasd
	
func get_wasd_cam():
	return get_wasd().normalized().rotated(Vector3.UP, $CameraPivot.rotation.y)
	
func move(delta):
	if armature.anim.is_using_root_motion():
		var m = armature.anim.get_root_motion().origin
		m = m.rotated(Vector3.UP, armature.rotation.y)
		velocity = m / delta
	else: 
		if using_gravity:
			add_force(Vector3.DOWN * 20)
		if velocity != Vector3.ZERO:
			armature.face_dir(velocity, delta)
	var _d = move_and_slide(velocity + force, Vector3.UP)
	velocity = Vector3.ZERO
	force = Vector3.ZERO
	var npc_args = {
			"function":"sync_move",
			"update":"", 
			"position":global_transform.origin, 
			"rotation":armature.rotation.y,
			"animation":armature.get_animation(), 
			"root_motion": armature.anim.is_using_root_motion(), 
			"uuid":int(name)}
	npc("sync_move", npc_args)
	#Server.npc(npc_args)
		
func set_velocity(v):
	velocity = v
	
func add_force(f):
	force += f

func play(anim:String, root_motion:=false):
	armature.play(anim, root_motion)

func sync_move(args):
	if is_dummy():
		if args.has("position"):
			global_transform.origin = args.position
		armature.rotation.y = args.rotation
		if args.animation != armature.get_animation() and args.animation != "":
			play(args.animation, args.root_motion)

func is_dummy():
	return name != str(Client.nid)
	
func get_ledge():
	return $Armature/Sensors/LedgeClimb.get_ledge()

func get_state(state):
	return state_machine.get_state(state)

func set_state(state):
	state_machine.set_state(state)

func npc(function, args):
	args["function"] = function
	args["uuid"] = int(name)
	Server.npc(args)

func equip(args):
	if ! args.has("call_number"):
		npc("equip", args)
		return
	armature.equip(args)
	
func unequip(args):
	armature.unequip(args)

func add_effect(e):
	$EffectManager.add_effect(e)

func emote(animation):
	get_state("Emote").animation = animation
	set_state("Emote")
	
func get_all_equipped():
	if items.get_durability() > 0:
		return [items]
	else:
		return []

func take_damage(args):
	var post_resist_damage = get_resisted_damage(args.damages)
	get_hitzone_damage(post_resist_damage)
	pass
	
func get_resisted_damage(damages):
	var item_list = get_all_equipped()
	print(damages)
	var return_list = damages.duplicate(true)
	for d in damages:
		for i in item_list:
			if !i.is_default() and i.current.resists.has(d):
				print(i.current.name, " hit for ", damages[d], " ", d, " damage")
				i.take_damage(d, damages[d])
				return_list.erase(d)
				break
	return return_list
	
func get_hitzone_damage(damages):
	for d in damages:
		var zone = "hp"
		if !is_on_floor():
			zone = "boots"
		elif blocking:
			zone = "offhand"
		elif attacking:
			zone = "mainhand"
		else:
			zone = "head"
		zone = get_hitzone_fallback(zone)
		if zone == "hp":
			print("HP damage for ", d)
			#need a check for status effects
		else:
			get_equipped(zone).take_damage(d, damages[d])
					
					
func get_hitzone_fallback(z):
	var i = get_equipped(z)
	if ! is_instance_valid(i) or i.is_default():
		if z == "offhand":
			z = "mainhand"
		else:
			z = "hp"
	return z
		
			
func get_equipped(slot):
	if slot == items.current.slot:
		return items
	else:
		return null

func get_skill(s):
	if items.current.skills.has(s):
		return items.current.skills[s]
	else:
		return 0
