extends Spatial

export(String) var item = "random"
export(bool) var one_shot = true

var net_stats = NetStats.new("loot_barrel")


func _ready() -> void:
	#net_stats.register()
	if item == "random":
		rand_item()
	else:
		item = Data.get_item(item).duplicate()
	$InteractableZone.set_action_label("Open Barrel")
	
	
func activate(host):
	host.add_item(item)
	$Barrel/AnimationPlayer.play("Open")
	yield(get_tree().create_timer(1.5), "timeout")
	if one_shot:
		queue_free()
	$Barrel/AnimationPlayer.queue("RESET")

func rand_item():
	item = Data.get_random_item()
	if !["Head", "Mainhand", "Offhand", "Boots"].has(item.get_slot())\
			or "naked" in item.index or "debug" in item.index:
		rand_item()
	else:
		item = item.duplicate()
