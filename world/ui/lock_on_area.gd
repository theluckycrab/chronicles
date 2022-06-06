extends Area

var lock_list = []
var max_lock_range = 20
var lock_target = null

func get_list():
	lock_target = null
	lock_list.clear()
	lock_list = get_overlapping_bodies()
	
func filter_list_to_lockable_targets(filter):
	var new_list = []
	for i in lock_list:
		if i.has_method("lock_on") and !filter.has(i):
			new_list.append(i)
	lock_list = new_list
	
func filter_list_by_distance():
	var pos = global_transform.origin
	var closest = max_lock_range
	for i in lock_list:
		var tpos = i.global_transform.origin
		var dist = pos.distance_to(tpos)
		if dist < closest:
			lock_target = i
			closest = dist
	
func get_lock_target(filter=[]):
	get_list()
	filter_list_to_lockable_targets(filter)
	filter_list_by_distance()
	return lock_target
