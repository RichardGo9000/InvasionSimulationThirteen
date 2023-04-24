extends Area2D

var team = -1  #0 neutral, 1 red team, 2 blue team
var id = -1
var shipCount = 0


func _ready():
	match team:
		1:	#Red Planet
			set_modulate(Color(1,0,0,1))
		2:	#Blue Planet
			set_modulate(Color(0.3,0.3,0.9,1))


func _on_Timer_timeout():
	if team !=0:
		$ShipCountLabel.visible = true
		shipCount += 1
		$ShipCountLabel.text = str(shipCount)
		


var tempClickCount = 0
func _on_Planet_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click") && prevent_double_click():
		tempClickCount += 1
		print("planet: ",id," clicked ",tempClickCount," times")
		
		if !source_defined():
			lvl.source = id
		elif source_defined() && source_reselected(id):
			lvl.source = -1
		elif source_defined() && !destination_defined():
			lvl.destination = id
			#create and send the fleet


func prevent_double_click():
	#will return false if user already clicked with .2 seconds otherwise toggle the clicked variable and return true
	if lvl.clicked:
		return false
	else:
		lvl.clicked = true
		return true


func source_defined():
	if lvl.source >= 0:
		return true
	else:
		return false
		
		
func destination_defined():
	if lvl.destination >= 0:
		return true
	else:
		return false
		
		
func source_reselected(selection:= -1):
	if selection == lvl.source:
		return true
	else:
		return false


func planet_on_my_team(planetId):
	if lvl.planets[planetId].team == team:
		return true
	else:
		return false 


#func _on_Planet_input_event(viewport, event, shape_idx):
#	if Input.is_action_just_pressed("click"):
#		print("clicked planet: ", id)
#		#if Globals.source == 0 && (team == 1 or team == 2):
#
#		#set source
#		if !source_defined() && planet_on_my_team(Globals.planets[id]):
#			Globals.source = id
#			print("source:",Globals.source," destination:",Globals.destination)
#
#		#clear source if clicked again
#		elif selection_matches_source(id):
#			Globals.source = -1
#			print("source:",Globals.source," destination:",Globals.destination)
#
#		#set destination & launch atack
#		elif source_defined():
#			Globals.destination = id
#			print("source:",Globals.source," destination:",Globals.destination)
#			create_fleet(Globals.planets[Globals.source])
#			Globals.flightplan()
#
#func selection_matches_source(id):
#	if source_defined() && Globals.source == id:
#		return true
#	else:
#		return false
#
#
#func source_defined():
#	if Globals.source != -1:
#		return true
#	else:
#		return false
#
#
#func destination_defined():
#	if Globals.source != -1:
#		return true
#	else:
#		return false
#
#
#func not_same_planet(planet1, planet2):
#	if planet1.id != planet2.id:
#		return true
#	else:
#		return false
#
#
#func planet_on_my_team(queryPlanet):
#	if Globals.planets[id].controllingTeam == Globals.currentTeam:
#		return true
#	else:
#		return false

