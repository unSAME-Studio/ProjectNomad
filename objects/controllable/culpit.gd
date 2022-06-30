extends StaticBody2D

class_name Culpit

var prebuild = preload("res://objects/buildings/Prebuild.tscn")

var base = null

export(String) var type = "wheel"
onready var action = Global.culpits_data[type]["action"]
onready var controllable = Global.culpits_data[type]["controllable"]


func _ready():
	$Sprite.set_texture(load("res://arts/culpits/%s.png" % type))
	
	base = get_parent().get_parent()
	
	connect("input_event", self, "_on_Culpit_input_event")
	connect("mouse_exited", self, "_on_Culpit_mouse_exited")
	
	$Control/PanelContainer/MarginContainer/HBoxContainer/Move.connect("pressed", self, "_on_moved")
	$Control/PanelContainer/MarginContainer/HBoxContainer/Destroy.connect("pressed", self, "_on_destroy")


func get_hint_text():
	return Global.culpits_data[type]["hint"]


func initial_control(body):
	print(name + " is being controller")


func stop_control(body):
	print("stopping " + name + " from controlling")


func _on_Culpit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 and event.is_pressed():
			print("player clicked on %s" % type)
			
			$Control.set_visible(!$Control.is_visible())


func _on_Culpit_mouse_exited():
	return 
	$Control.set_visible(false)


func _on_moved():
	print(type + "is being moved")
	
	modulate.a = 0.5
	$Control.set_visible(false)
	
	var p = prebuild.instance()
	p.card = self
	p.type = type
	get_tree().get_current_scene().get_node("Node2D").add_child(p)


func canceled_build():
	modulate.a = 1
	$Control.set_visible(true)


func _on_destroy():
	print(type + "have been destroyed")
	
	queue_free()
