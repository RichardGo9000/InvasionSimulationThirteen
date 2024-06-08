extends Node2D

signal planet_selected

@onready var count_label = $Label
@onready var animation = $AnimatedSprite2D
var ship_count: int = 0

var id: int

func _ready():
	pass
	#print("planet ready")

func _on_touch_screen_button_pressed():
	print("touch detected") # Replace with function body.
	if Global.source == Global.null_vector:
		print("setting Global.source to ", self.global_position)
		Global.source = self.global_position
		Global.source_id = self.id
		Global.src_id = self.id
		$AnimatedSprite2D.play("selected")
	elif Global.destination == Global.null_vector:
		$AnimatedSprite2D.play("selected")
		Global.destination = self.global_position
		Global.dst_id = self.id
		print("Ready to launch fleet(from planet.tscn)")
		emit_signal("planet_selected")


func _on_timer_timeout():
	ship_count += 1
	count_label.text = str(ship_count)
	
	
	
	
	
	
	
	
	
	
	
