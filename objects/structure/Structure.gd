extends StaticBody2D

signal select
signal deselect

class_name Structure

var prebuild = preload("res://objects/buildings/Prebuild.tscn")

var base = null
var wearing = false

var build_point

export(String) var type = "Storage"
var data setget ,get_data

#onready var action = Global.culpits_data[type]["action"]

onready var controllable = false


func _ready():
	#$Sprite.set_texture(load("res://arts/culpits/%s.png" % type))
	
	base = get_parent().get_parent()
	
	connect("input_event", self, "_on_Culpit_input_event")
	connect("select", self, "on_select")
	connect("deselect", self, "on_deselect")
	
	# don't allow player to control if not controllable
	if not controllable:
		set_collision_layer_bit(0, true)
		set_collision_layer_bit(3, false)


func get_hint_text():
	return 'Interact'


func initial_control(body):
	print(type + " is being controller")
	
	# don't initial operate if player is wearing
	if not wearing:
		operate(body)


func stop_control(body):
	print("stopping " + type + " from controlling")


# snap body to predefined point
func snap_position(body):
	if not wearing:
		body.set_global_position($ControlPos.get_global_position())


func _on_Culpit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.get_button_index() == 2 and event.is_pressed():
			print("player clicked on %s" % type)
			
			#Global.player.edit_culpit(self)


func operate(player):
	print(type + "Being Used")


func _on_moved():
	if not Global.player.enter_building_mode():
		return
	
	print(type + "is being moved")
	
	modulate.a = 0.3
	Global.player.edit_culpit(self)
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	var p = prebuild.instance()
	p.card = self
	p.type = type
	p.data = data
	get_tree().get_current_scene().get_node("Node2D").add_child(p)


func canceled_build():
	modulate.a = 1
	Global.player.edit_culpit(self)
	
	$CollisionShape2D.set_deferred("disabled", false)


func _on_destroy():
	print(type + "have been destroyed")
	if build_point:
		build_point.activate_build()
	#throw(Global.player)
	queue_free()


func on_select():
	return


func on_deselect():
	return


func powered():
	pass


func unpowered():
	pass


func get_data():
	return null
