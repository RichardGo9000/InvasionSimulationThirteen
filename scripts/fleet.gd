extends Node2D

signal fleet_arrived

var ship_count: int = 0
var src_id
var dst_id
var path_name

func _ready():
	pass #print("fleet underway (from fleet.tscn)")


# TODO on arrival add ship count from fleet to ship count of planet
