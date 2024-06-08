extends Node2D

@onready var planet = preload("res://scenes/planet.tscn")
@onready var fleet = preload("res://scenes/fleet.tscn")
@onready var flightplans = $Flightplans
@onready var screen_dims: Vector2
var x_limit
var y_limit

var planets: Array = []
var planet_counter: int = 0

var fleet_counter: int = 0

var rng = RandomNumberGenerator.new()

func _ready():
	print("screen dims",get_viewport().get_visible_rect().size)
	screen_dims = get_viewport().get_visible_rect().size
	x_limit = screen_dims.x
	y_limit = screen_dims.y
	#print("running map.gd")
	#_generate_planet(Vector2(500,500))
	#_generate_planet(Vector2(100,100))
	_generate_sector(4)

func _generate_planet(grid_pos: Vector2) -> void:
	var n: int = planet_counter
	planets.append(planet.instantiate())
	planets[n].id = str(n)
	print("spawning planet ", planets[n].id)
	planets[n].global_position = grid_pos
	planets[n].name = "Planet" + str(n)
	flightplans.get_parent().add_child(planets[n])
	planets[n].connect("planet_selected", launch_fleet)
	planet_counter += 1

## _check_overlap() checks if any planet is colliding with another on spawn
#func _overlaping(grid_pos: Vector2, radius: int) -> bool:
func _overlaping(grid_pos: Vector2) -> bool:
	var border = 120
	if planets.size() >= 1:
		for planet in planets:
			if abs(grid_pos.x - planet.global_position.x) < border:
				if abs(grid_pos.y - planet.global_position.y) < border:
					return true
	return false

func _select_quadrant(quadrant: int) -> Vector2:
	var screen_width: int = screen_dims.x
	var screen_height: int = screen_dims.y
	var half_width: int = screen_width / 2
	var half_height: int = screen_height / 2
	
	var border_margin = 50
	
	var x_floor = 0 + border_margin
	var x_roof = screen_width - border_margin
	var y_floor = 0 + border_margin
	var y_roof = screen_height - border_margin
	
	var solution_coordinates: Vector2 = Vector2.ZERO
	
	match quadrant:
		1:
			# Top Right
			x_floor = half_width
			# x_roof defined above
			# y_floor defined above
			y_roof = half_height
		2:
			# Top Left
			# x_floor defined above
			x_roof = half_width
			# y_floor defined above
			y_roof = half_height
		3:
			# Bottom Left
			# x_floor defined above
			x_roof = half_width
			y_floor = half_height
			# y_roof defined above
		4:
			# Bottom Right
			x_floor = half_width
			# x_roof defined above
			y_floor = half_height
			# y_roof defined above
	# get random coordinates within defined bounds
	var x: int = randi_range(x_floor, x_roof)
	var y: int = randi_range(y_floor, y_roof)
	solution_coordinates = Vector2(x, y)
	return solution_coordinates

func _generate_sector(total_planets):
	#_generate_planet(_select_quadrant(2))
	#_generate_planet(_select_quadrant(4))
	#_generate_planet(_select_quadrant(4))
	var c: int = 0
	while c < total_planets:
		var grid_pos = _select_quadrant(0)
		if !_overlaping(grid_pos):
			_generate_planet(grid_pos)
		# TODO loop over several times to try to find a location but limit max iterations to 10 or something
		c += 1
	


func launch_fleet():
	# on click send all ships
	# on long press present prompt of how many ships to send
	# on second click clear origin
	_generate_fleet(1)
	
func receive_fleet(path_name):#path_name: String):
	# Fleet has arrived, add shipos to planet count and remove fleet pathfollow and path2d from scene
	print("path_name", path_name)
	pass

func _clear_src_dst():
	Global.source = Global.null_vector
	Global.destination = Global.null_vector
	Global.source_id = -1

func _generate_fleet(fleet_ship_count):
	fleet_counter += 1
	var path: Path2D         = Path2D.new()
	var curve: Curve2D       = Curve2D.new()
	var follow: PathFollow2D = PathFollow2D.new()
	var new_fleet = fleet.instantiate()
	new_fleet.dst_id = Global.dst_id
	new_fleet.src_id = Global.src_id
	curve.clear_points()
	curve.add_point(Global.source)
	curve.add_point(Global.destination)
	path.curve = curve
	var path_name = "path" + str(fleet_counter)
	path.name = path_name
	path.add_child(follow)
	follow.add_child(new_fleet)
	new_fleet.ship_count = planets[Global.source_id].ship_count
	new_fleet.path_name = path_name
	new_fleet.dst_id = Global.dst_id
	planets[Global.source_id].ship_count = 0
	_clear_src_dst()
	follow.loop = false
	flightplans.add_child(path)

func _physics_process(delta):
	_move_fleets(delta)

func _move_fleets(delta):
	var i: int = 0
	while i < flightplans.get_child_count():  
		#this way of accessing fligghtplans may cause an error with many concurrent flights
		#it is likely that the error may be a few pixels per second in a random fleets progress
		flightplans.get_child(i).get_child(0).progress += 500 * delta
		if flightplans.get_child(i).get_child(0).progress_ratio >= 0.98:
			print("fleet size ", flightplans.get_child(i).get_child(0).get_node("Fleet").ship_count)
			var dst = flightplans.get_child(i).get_child(0).get_node("Fleet").dst_id
			var src = flightplans.get_child(i).get_child(0).get_node("Fleet").src_id
			print("src ", src)
			print("planet children ", planets[dst].get_children())
			planets[dst].get_child(3).play("unselected") # TODO have a timer keep these selected for a sec
			planets[src].get_child(3).play("unselected")
			planets[dst].ship_count += flightplans.get_child(i).get_child(0).get_node("Fleet").ship_count
			print("destination reached")
			# skip the signal from the fleet and just add ship count to dst then delete here
			print(flightplans.get_children())
			flightplans.remove_child(flightplans.get_child(i))
			print(flightplans.get_children())
		i += 1
