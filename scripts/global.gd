extends Node

var null_vector: Vector2 = Vector2(-1, -1)
var source: Vector2  = null_vector
var destination: Vector2 = null_vector

var fleet_array: Array = []
var planet_array: Array = []

var source_id: int = -1
var dst_id: int = -1
var src_id: int = -1
var current_team: String = ""

var fleet_counter: int = 0


var teams = ["red", "blue", ]
var team_count = teams.size()
