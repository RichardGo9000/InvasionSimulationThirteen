extends Area2D

var team := -1
var source := -1
var destination := -1
var ship_count := 0
var velocity := 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_team(selected_team):
	team = selected_team
	if team == 1:
		$AnimatedSprite2D.set_modulate(Color(1,0,0,1))
	elif team == 2:
		$AnimatedSprite2D.set_modulate(Color(0,0,1,1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
