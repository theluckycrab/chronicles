extends Area

var lock_list = []
var max_lock_range = 10
var lock_target = null

func get_list():
	lock_target = null
	lock_list.clear()
	lock_list = get_overlapping_bodies()
	
func filter_list_to_lockable_targets():
	var new_list = []
	for i in lock_list:
		if i.has_method("lock_on") and i.net_stats.netID != Network.get_nid():
			new_list.append(i)
	lock_list = new_list
	
func filter_list_by_distance():
	var pos = global_transform.origin
	var closest = max_lock_range
	if !lock_list.empty():
		lock_target = lock_list[0]
	for i in lock_list:
		var tpos = i.global_transform.origin
		if pos.distance_to(tpos) < closest:
			lock_target = i
			closest = pos.distance_to(tpos)
			
		
	
func get_lock_target():
	get_list()
	filter_list_to_lockable_targets()
	filter_list_by_distance()
	return lock_target
