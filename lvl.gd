extends Node2D

const PLANET = preload("res://PlanetaryBodies/Planet.tscn")
var planets = []
var fleets = []
var source = -1
var destination = -1
var clicked = false


func _ready():
	spawn_planet(0, 273, 684)
	spawn_planet(1, 1000, 300)
	spawn_planet(1, 1000, 600)
	spawn_planet(2, 1500, 800)
	

func send_fleet():
	planets[source].shipCount = 0
	print("source index:",source)
	print("source: ",source," (which has ",planets[source].shipCount,")")
	
	print("ship count: ",planets[source].shipCount)
	#planets[2].ShipCountLabel.text = "606"
	planets[source].ShipCountLabel.text = str(planets[source].shipCount)
	print("Sending fleet")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func spawn_planet(planetTeam, x, y):
	var id = len(planets)
	#print(id)
	planets.append(PLANET.instance())
	get_parent().call_deferred("add_child", planets[id])
	planets[id].position.x = x
	planets[id].position.y = y
	planets[id].id = id
	planets[id].team = planetTeam


func _on_ClickTimer_timeout():
	clicked = false
