extends StaticBody2D

signal select
signal deselect

class_name Culpit

var prebuild = preload("res://objects/buildings/Prebuild.tscn")
var entity = preload("res://objects/entities/Entity.tscn")

var base = null	# the base this culpit rest on
var user = null	# the owner of this culpit, currently using it
var wearing = false

var build_point

var slotted = null

export(String) var type = "wheel"
var data setget ,get_data

onready var action = Global.culpits_data[type]["action"]
onready var controllable = true


func _ready():
	$Sprite.set_texture(load("res://arts/culpits/%s.png" % type))
	
	base = get_parent().get_parent()
	if base.has_method('get_base'):
		base = base.get_base()
	
	connect("input_event", self, "_on_Culpit_input_event")
	connect("select", self, "on_select")
	connect("deselect", self, "on_deselect")
	
	# don't allow player to control if not controllable
	if not controllable:
		set_collision_layer_bit(0, true)
		set_collision_layer_bit(3, false)


func get_hint_text():
	return Global.culpits_data[type]["hint"]


func initial_control(body):
	print(type + " is being controller")
	user = body
	
	# don't initial operate if player is wearing
	if not wearing:
		operate(body)


func stop_control(body):
	print("stopping " + type + " from controlling")
	user = null


# snap body to predefined point
func snap_position(body):
	if not wearing:
		body.set_global_position($ControlPos.get_global_position())


func _on_Culpit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.get_button_index() == 2 and event.is_pressed():
			print("player clicked on %s" % type)
			
			Global.player.edit_culpit(self)
			
			get_viewport().set_input_as_handled()


func throw(player,_build = false):
	
	var e = entity.instance()
	e.type = type
	e.data = get_data()
	
	if _build:
		e.buildable = true
	if player.base:
		player.base.add_child(e)
	else:
		get_tree().get_current_scene().get_node("Node2D").add_child(e)
	
	e.set_global_position(get_global_position())
	
	e.throw(player,_build)
#	e.velocity = player.get_facing().normalized() * 1000
#	e.throwing = true
#	e.set_wearing(false)
	call_deferred("queue_free")


func set_wearing(value):
	wearing = value
	# if player is weearing this, it shouldn't be interactable or collision
	if wearing:
		set_collision_layer_bit(3, false)
	else:
		set_collision_layer_bit(3, true)


func operate(player):
	print(type + "Being Used")


func _on_moved():
	if not Global.player.enter_building_mode():
		return
	if build_point:
		build_point.activate_build()
	print(type + "is being moved")
	
	modulate.a = 0.3
	Global.player.edit_culpit(self)
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	var p = prebuild.instance()
	p.card = self
	p.type = type
	p.data = data
	get_tree().get_current_scene().get_node("Node2D").add_child(p)
	return p


func canceled_build():
	modulate.a = 1
	Global.player.edit_culpit(self)
	
	if build_point:
		build_point.end_build()
	$CollisionShape2D.set_deferred("disabled", false)


func _on_destroy():
	destroy()
	print(type + "have been destroyed")
	if build_point:
		build_point.activate_build()
	stop_control(Global.player)
	throw(Global.player)
	call_deferred("queue_free")

func destroy():
	pass
	
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
