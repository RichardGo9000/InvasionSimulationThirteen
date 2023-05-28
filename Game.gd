extends Node2D

var planets = []
var fleets = []
var PLANET = load("res://planetary_bodies/planet.tscn")
var FLEET = load("res://fleet.tscn")
var clicked = false
var source := -1
var destination := -1


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_planet(2)
	spawn_planet(1)
	spawn_planet()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if len(fleets) > 0:
		#fleets[0].position.y += 10
		for n in fleets:
			n.position.x += 3.1622776602
			n.position.y += 3.1622776602


func random_x():
	return randi_range(0, 1920)


func random_y():
	return randi_range(0, 1080)


func spawn_fleet(current_team := -1):
	var i = len(fleets)
	fleets.append(FLEET.instantiate())
	fleets[i].position.x = planets[source].position.x - 60
	fleets[i].position.y = planets[source].position.y
	fleets[i].set_team(current_team)
	add_child(fleets[i])
	
func _chart_course(fleet_id):
	# A^2 + B^2 = C^2
	pass
	
func _calculate_distance(fleet_id):
	#compare source planet location to destination planet location
	#fleets will fly behind non target planets
	pass

	#EXAMPLE#
#	var direction = mob_spawn_location.rotation + PI / 2
#	direction += randf_range(-PI / 4, PI / 4)
#	mob.rotation = direction
#	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
#	mob.linear_velocity = velocity.rotated(direction)


	
#func _on_MobTimer_timeout():
#	var mob = mob_scene.instantiate()
#
#	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
#	mob_spawn_location.offset = randi()
#
#	var direction = mob_spawn_location.rotation + PI / 2
#
#	mob.position = mob_spawn_location.position
#
#	direction += randf_range(-PI / 4, PI / 4)
#	mob.rotation = direction
#
#	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
#	mob.linear_velocity = velocity.rotated(direction)
#
#	add_child(mob)
	#END EXAMPLE#


func spawn_planet(team := 0):
	var i = len(planets)
	planets.append(PLANET.instantiate())
	planets[i].position.x = random_x()
	planets[i].position.y = 600 #random_y()
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
	
	
func remove_ships(planet_id, departing_ship_count):
	planets[planet_id].ship_count -= departing_ship_count
	

func add_ships(planet_id, arriving_ship_count):
	planets[planet_id].ship_count += arriving_ship_count
	
	
func launch_fleet():
	var ships_in_fleet = get_fleet_size(source)
	remove_ships(source, ships_in_fleet)
	#var fleet_index = len(fleets)
	spawn_fleet(planets[source].team)
	add_ships(destination, ships_in_fleet)
	print("launching fleet from ",source," to ",destination," with ",ships_in_fleet," ships.")
	_reset_source()
	_reset_destination()


func teleport_fleet():
	var ships_in_fleet = get_fleet_size(source)
	remove_ships(source, ships_in_fleet)
	add_ships(destination, ships_in_fleet)
	print("launching fleet from ",source," to ",destination," with ",ships_in_fleet," ships.")
	_reset_source()
	_reset_destination()


func fleet_arrival(planet_id):
	#compare team of fleet to team of planet
	pass

func battle(planet_id, fleet_size):
	#comparethe invading fleet to descending fleet to determine who wins the battle for the planet
	if planets[planet_id].ship_count >= fleet_size:
		#planet remains under defender control
		pass
	elif planets[planet_id].ship_count < fleet_size:
		#planet is taken over by invading ships
		pass	
	
	
	
