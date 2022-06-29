extends Spatial

export(String) var item = "random"
export(bool) var one_shot = true
var looted = false

var net_stats = NetStats.new("loot_barrel")


func _ready() -> void:
	#net_stats.original_instance_id = get_instance_id()
	#net_stats.register()
	if item == "random":
		rand_item()
	else:
		item = Data.get_item(item).duplicate()
	$InteractableZone.set_action_label("Open Barrel")
	call_deferred("send_position")
	
	
func send_position():
	if net_stats.is_master:
		net_stats.npc("position", {position=global_transform.origin})
	
		
func position(args):
	global_transform.origin = args.position
	
	
func activate(host):
	if looted:
		return
	host.add_item(item)
	if Network.get_net_object(net_stats.netID):
		net_stats.npc("set_looted", {})
	else:
		set_looted({})
		yield(get_tree().create_timer(1.5), "timeout")
		queue_free()
	#$Barrel/AnimationPlayer.queue("RESET")

func rand_item():
	item = Data.get_random_item()
	if !["Head", "Mainhand", "Offhand", "Boots", "Consumable"].has(item.get_slot())\
			or "naked" in item.index or "debug" in item.index:
		rand_item()
	else:
		item = item.duplicate()

func set_looted(_args):
	looted = true
	$Barrel/AnimationPlayer.play("Open")
	yield($Barrel/AnimationPlayer, "animation_finished")
	if one_shot:
		net_stats.unregister()
