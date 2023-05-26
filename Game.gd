extends Node2D

var planets = []
var PLANET = load("res://planetary_bodies/planet.tscn")
var clicked = false
#var planet_id
var source := -1
var destination := -1


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_planet(2)
	spawn_planet(1)
	spawn_planet()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func random_x():
	return randi_range(0, 1920)


func random_y():
	return randi_range(0, 1080)


func spawn_planet(team := 0):
	var i = len(planets)
	planets.append(PLANET.instantiate())
	planets[i].position.x = random_x()
	planets[i].position.y = random_y()
	planets[i].planet_id = i
	planets[i].set_team(team)
	if team != 0:
		planets[i].build_ships()
	add_child(planets[i])
	var function_name = "planet_clicked_" + str(i)
#	planets[i].connect("planet_clicked", self, "planet_click_handler", "planet_id")
	planets[i].planet_clicked.connect(Callable(planet_click_handler))


func planet_click_handler(planet_id):
	clicked = true
	print("planet ",planet_id," clicked and received")
	_set_fleet_orders(planet_id)


#Double click protection
func _on_click_timer_timeout():
	clicked = false
	

func _source_selected():
	if source != -1:
		return true
	else:
		return false


func _source_reselected(planet_id):
	if source == planet_id:
		return true
	else:
		return false


func _destination_selected():
	if destination != -1:
		return true
	else:
		return false


func _set_fleet_orders(planet_id):
	if !_source_selected():
		source = planet_id
		print("source: ",source)
	elif _source_reselected(planet_id):
		_reset_source()
		print("source: ",source)
	elif _source_selected():
		destination = planet_id
		print("destination: ",destination)
		launch_fleet()


func _reset_source():
	source = -1


func _reset_destination():
	destination = -1


func get_fleet_size(planet_id):
	return planets[planet_id].ship_count
	
	
func remove_ships_from_stardock(planet_id, departing_ship_count):
	planets[planet_id].ship_count -= departing_ship_count
	
	
func launch_fleet():
	var ships_in_fleet = get_fleet_size(source)
	remove_ships_from_stardock(source, ships_in_fleet)
	print("launching fleet from ",source," to ",destination," with ",ships_in_fleet," ships.")
	_reset_source()
	_reset_destination()
