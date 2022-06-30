extends StaticBody2D

class_name Culpit

var base = null

export(String) var type = "wheel"
onready var action = Global.culpits_data[type]["action"]
onready var controllable = Global.culpits_data[type]["controllable"]


func _ready():
	$Sprite.set_texture(load(Global.culpits_data[type]["icon"]))
	
	base = get_parent().get_parent()


func get_hint_text():
	return Global.culpits_data[type]["hint"]


func initial_control(body):
	print(name + " is being controller")


func stop_control(body):
	print("stopping " + name + " from controlling")
