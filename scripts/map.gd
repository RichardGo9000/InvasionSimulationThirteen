extends Node2D

@onready var planet = preload("res://scenes/planet.tscn")
@onready var fleet = preload("res://scenes/fleet.tscn")
@onready var flightplans = $Flightplans

var planets: Array = []
var planet_counter: int = 0

var rng = RandomNumberGenerator.new()

func _ready():
	print("screen dims",get_viewport().get_visible_rect().size)
	#print("running map.gd")
	#_generate_planet(Vector2(500,500))
	#_generate_planet(Vector2(100,100))
	_generate_sector(2)

func _generate_planet(grid_pos: Vector2) -> void:
	var n: int = planet_counter
	planets.append(planet.instantiate())
	planets[n].id = "p" + str(n)
	planets[n].global_position = grid_pos
	flightplans.get_parent().add_child(planets[n])
	planets[n].connect("planet_selected", launch_fleet)
	planet_counter += 1

func _generate_sector(total_planets):
	var c: int = 0
	while c < total_planets:
		var x: int = randi_range(50, 950)
		var y: int = randi_range(50, 950)
		var grid_pos = Vector2(x,y)
		_generate_planet(grid_pos)
		c += 1
	


func launch_fleet():
	_generate_fleet(1)

func _clear_src_dst():
	Global.source = Global.null_vector
	Global.destination = Global.null_vector

func _generate_fleet(fleet_ship_count):
	var path: Path2D         = Path2D.new()
	var curve: Curve2D       = Curve2D.new()
	var follow: PathFollow2D = PathFollow2D.new()
	var new_fleet = fleet.instantiate()
	curve.clear_points()
	curve.add_point(Global.source)
	curve.add_point(Global.destination)
	_clear_src_dst()
	path.curve = curve
	path.add_child(follow)
	follow.add_child(new_fleet)
	follow.loop = false
	flightplans.add_child(path)

func _physics_process(delta):
	var i: int = 0
	while i < flightplans.get_child_count():  
		#this way of accessing fligghtplans may cause an error with many concurrent flights
		#it is likely that the error may be a few pixels per second in a random fleets progress
		flightplans.get_child(i).get_child(0).progress += 500 * delta
		if flightplans.get_child(i).get_child(0).progress_ratio >= 0.98:
			print("destination reached")
			flightplans.remove_child(flightplans.get_child(i))
		i += 1
