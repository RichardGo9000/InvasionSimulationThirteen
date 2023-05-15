extends Area2D

var ship_count := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func show_label():
	$Label.visible = true


func set_text(number_text):
	$Label.text = number_text


func build_ships():
	show_label()
	$ShipBuilderTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ship_builder_timer_timeout():
	ship_count += 1
	set_text(str(ship_count))
