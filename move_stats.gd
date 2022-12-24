extends Node
class_name MoveStats

var base_speed = 15
var move_speed = base_speed
var sprint_speed = base_speed * 4
var sprint_acceleration = base_speed
var turn_speed = 5
var turn_angle_limit = 30
var rotation_speed = 15#0.4
var velocity = Vector3.ZERO
var force = Vector3.ZERO
var using_gravity = true
