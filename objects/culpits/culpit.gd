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

var powered = false

export(String) var type = "wheel"
var data setget ,get_data

onready var action = Global.culpits_data[type]["action"]
onready var controllable = true

var click_initial_point = Vector2.ZERO
var click_drag_distance = 0.0
var click_hold = false
var click_hold_time = 0.0


func _ready():
	$Sprite.set_texture(load("res://arts/culpits/%s.png" % type))
	
	# reset the hint graphics
	$Sprite.set_modulate(Color("d0d0d0"))
	
	base = get_parent().get_parent()
	if base.has_method('get_base'):
		base = base.get_base()
	
	connect("input_event", self, "_on_Culpit_input_event")
	connect("select", self, "on_select")
	connect("deselect", self, "on_deselect")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
	if Global.player and is_instance_valid(Global.player):
		Global.player.play_sound("Build", get_global_position())
	
	# don't allow player to control if not controllable
	if not controllable:
		set_collision_layer_bit(0, true)
		set_collision_layer_bit(3, false)


func _process(delta):
	# check for mouse dragging and holding
	if click_hold:
		# hold to destroy
		click_hold_time += delta
		
		$Sprite.set_self_modulate(Color("ffffff").linear_interpolate(Color("600000"), click_hold_time))
		
		if click_hold_time >= 1.0:
			_on_destroy()
		
		# drag to move
		var dis = click_initial_point.distance_to(get_global_mouse_position())
		$Sprite.set_scale(lerp(Vector2(1, 1), Vector2(1, 3), dis / 56.0))
		
		if dis >= 56.0:
			_on_moved()
			click_hold = false
			click_hold_time = 0.0
			on_deselect()


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
	if not wearing and body:
		body.set_global_position($ControlPos.get_global_position())


# Use mouse to interacte with the item directly
func _on_Culpit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		# right click
		if event.get_button_index() == 3 and event.is_pressed():
			print("player clicked on %s" % type)
			
			Global.player.edit_culpit(self)
			
			get_tree().set_input_as_handled()
		
		# right click
		if event.get_button_index() == 2 and event.is_pressed():
			click_hold = true
			click_initial_point = get_global_mouse_position()


func _unhandled_input(event):
	if click_hold == true:
		if event is InputEventMouseButton:
			if event.get_button_index() == 2 and not event.is_pressed():
				click_hold = false
				click_hold_time = 0.0
				click_initial_point = Vector2.ZERO
				
				var tween = create_tween().set_trans(Tween.TRANS_SINE)
				tween.tween_property($Sprite, "scale", Vector2(1, 1), 0.1)
				tween.parallel().tween_property($Sprite, "self_modulate", Color("ffffff"), 0.1)


func _on_mouse_entered():
	print('selected')
	print(self)
	Global.player.mouse_select_culpit = self


func throw(player,_build = false, force = 1000):
	
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
	
	e.throw(player,_build, force)
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
	
	if Global.player and is_instance_valid(Global.player):
		Global.player.play_sound("Destroy", get_global_position())
	
	stop_control(Global.player)
	throw(Global.player)
	call_deferred("queue_free")


func destroy():
	pass


func on_select():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Sprite, "scale", Vector2(1.2, 1.2), 0.1)


func on_deselect():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Sprite, "scale", Vector2(1, 1), 0.1)


func on_in_range():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Sprite, "scale", Vector2(1.06, 1.06), 0.1)
	tween.parallel().tween_property($Sprite, "modulate", Color("ffffff"), 0.1)


func on_out_range():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Sprite, "scale", Vector2(1, 1), 0.1)
	tween.parallel().tween_property($Sprite, "modulate", Color("a9a9a9"), 0.1)


func powered():
	if not powered:
		powered = true


func unpowered():
	if powered:
		powered = false


func get_data():
	return null
