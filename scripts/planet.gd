extends Node2D

signal planet_selected

var id = ""

func _ready():
	print("planet ready")

func _on_touch_screen_button_pressed():
	print("touch detected") # Replace with function body.
	if Global.source == Global.null_vector:
		print("setting Global.source to ", self.global_position)
		Global.source = self.global_position
	elif Global.destination == Global.null_vector:
		Global.destination = self.global_position
		print("Ready to launch fleet(from planet.tscn)")
		emit_signal("planet_selected")

