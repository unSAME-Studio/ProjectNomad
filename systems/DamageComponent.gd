extends Node2D

export var health_max = 100
onready var health = health_max
export var autoheal = false
export var autoheal_speed = 1

# data for no default drop
export(Array) var drop_types = []
export(int) var drop_amount = 1

var saved_scale = Vector2(1,1)

var entity = preload("res://objects/entities/Entity.tscn")


func _ready():
	$CanvasLayer/Control/ProgressBar.set_max(health_max)
	if get_parent().get_class() != 'RigidBody2D':
		saved_scale = get_global_scale()
	
func _enter_tree():
	pass
	
func damage(dealer, amount):
	#print("%s hit by %s | %d - %d" % [get_parent().get_name(), dealer.get_name(), health, amount])
	
	# ignore if self damage
	if dealer == self.get_parent():
		return false
	if "base" in self.get_parent():
#		print(dealer)
#		print(get_parent().base)
		if dealer == self.get_parent().base:
			return false
	# show bar when first hit
	if health == health_max:
		$CanvasLayer/Control.show()
	
	# start the hiding ui timer
	$CanvasLayer/Control.show()
	$Timer.start()
	
	# start the autoheal timer
	if autoheal == true:
		$Autoheal.start()
	
	health = clamp(health - amount, 0, health_max)
	$CanvasLayer/Control/ProgressBar.set_value(health)
	# create damage effect
	var dmg_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	dmg_tween.tween_property(get_parent(), "modulate", Color(0, 0, 0, 0.5), 0.08)
	dmg_tween.parallel().tween_property(get_parent(), "scale", saved_scale * 0.9, 0.08)
	dmg_tween.parallel().tween_property($CanvasLayer/Control/ProgressBar, "modulate", Color("952b2b"), 0.08)
	dmg_tween.tween_property(get_parent(), "modulate", Color.white, 0.08)
	dmg_tween.parallel().tween_property(get_parent(), "scale", saved_scale * 1, 0.08)
	dmg_tween.parallel().tween_property($CanvasLayer/Control/ProgressBar, "modulate", Color.white, 0.08)
	
	$Hit.play()
	
	if get_parent().has_method("_on_damage"):
		get_parent()._on_damage()
	
	if health <= 0:
		if get_parent().has_method("_on_destroy"):
			get_parent()._on_destroy()
		else:
			_on_destroy()
	return true


func reset():
	$CanvasLayer/Control/ProgressBar.set_max(health_max)
	health = health_max
	$CanvasLayer/Control.hide()


func heal(dealer, amount):
	#print("%s heal by %s | %d + %d" % [get_parent().name, dealer.name, health, amount])
	
	health = clamp(health + amount, 0, health_max)
	$CanvasLayer/Control.show()
	$Timer.start()
	# if full don't set value and hide bar
	if health == health_max:
		$CanvasLayer/Control.hide()
		
		# stop autoheal timer
		$Autoheal.stop()
	else:
		$CanvasLayer/Control/ProgressBar.set_value(health)
	
	# create healing effect
	var heal_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	heal_tween.tween_property(get_parent(), "modulate", Color("c6ffce"), 0.08)
	heal_tween.parallel().tween_property(get_parent(), "scale", saved_scale * 1.1, 0.08)
	heal_tween.parallel().tween_property($CanvasLayer/Control/ProgressBar, "modulate", Color("c6ffce"), 0.08)
	heal_tween.tween_property(get_parent(), "modulate", Color.white, 0.08)
	heal_tween.parallel().tween_property(get_parent(), "scale", saved_scale * 1, 0.08)
	heal_tween.parallel().tween_property($CanvasLayer/Control/ProgressBar, "modulate", Color.white, 0.08)


func _process(delta):
	if $CanvasLayer/Control.is_visible():
		$CanvasLayer/Control.set_position(get_parent().get_global_transform_with_canvas().get_origin() + Vector2(0, -70))

# this on destory only work if parent doesn't have a _on_destory function
func _on_destroy():
	for i in range(drop_amount):
		var e = entity.instance()
		e.type = drop_types[randi() % drop_types.size()]
		e.data = null
		
		get_tree().get_current_scene().get_node("Node2D").add_child(e)
		
		e.set_global_position(get_global_position() + Vector2(rand_range(-100, 100), rand_range(-100, 100)))
		
		e.throw(Global.player, false)
		
		get_parent().queue_free()


func _on_Timer_timeout():
	$CanvasLayer/Control.hide()


func _on_Autoheal_timeout():
	heal(self, autoheal_speed)
