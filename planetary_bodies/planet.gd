extends Area2D

var ship_count := 0
var planet_id := 0
var team := 0

signal planet_clicked(id)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_team(selected_team):
	team = selected_team
	if team == 1:
		$AnimatedSprite2D.set_modulate(Color(1,0,0,1))
	elif team == 2:
		$AnimatedSprite2D.set_modulate(Color(0,0,1,1))


func set_text(new_number):
	$ShipCountLabel.text = str(new_number)


func build_ships():
	$ShipCountLabel.visible = true
	$BuildShipTimer.start(true)
	ship_count = 0


func _on_build_ship_timer_timeout():
	ship_count += 1
	set_text(ship_count)


func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		print("clicked planet ",planet_id)
		emit_signal("planet_clicked", planet_id)
