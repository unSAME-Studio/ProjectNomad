extends Area2D


signal built

var card

var type = ""
var hovering = true
var can_build = true
var base = null


func _ready():
	$Sprite.set_texture(load(Global.culpits_data[type]["icon"]))


func check_build_condition() -> bool:
	if get_global_position().distance_to(Global.player.get_global_position()) > 300:
		$Hint.set_text("Too far!")
		return false
	
	var on_floor = false
	
	# overlapping check
	for i in get_overlapping_bodies():
		if i.get_collision_layer() in [1, 8]:
			$Hint.set_text("Blocked!")
			return false
		
		elif on_floor == false and i.get_collision_layer() == 2:
			on_floor = true
			base = i
	
	# floor check
	if not on_floor:
		$Hint.set_text("Not on floor!")
		return false
	
	$Hint.set_text("")
	return true


func _process(delta):
	# check if player can build here
	if check_build_condition():
		can_build = true
		set_modulate(Color.white)
	else:
		can_build = false
		set_modulate(Color.red)
	
	# move to mouse when hovering
	if hovering:
		set_global_position(get_global_mouse_position())


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 and event.is_pressed():
			#print(get_global_position().distance_to(Global.player.get_global_position()))
			
			# check if in range
			if can_build:
				hovering = false
				finish_build()
		
		# right click cancel
		elif event.get_button_index() == 2 and event.is_pressed():
			card.set_disabled(false)
			card.set_modulate(Color.white)
			queue_free()


func finish_build():
	var c = load("res://objects/controllable/Culpit.tscn").instance()
	c.base = base
	c.type = type
	
	base.get_node("objects").add_child(c)
	c.set_global_position(get_global_mouse_position())
	
	card.queue_free()
	queue_free()
