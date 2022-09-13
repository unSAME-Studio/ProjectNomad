extends KinematicBody2D

signal select
signal deselect

class_name Entity

const SNAP_RANGE = 300

export(String) var type = "nano"
var data = null
var action = true
var wearing = false

var throwing = false
var velocity = Vector2.ZERO

var buildable = false


func _ready():
	connect("select", self, "on_select")
	connect("deselect", self, "on_deselect")
	connect("input_event", self, "_on_Entity_input_event")
	connect("mouse_entered", self, "_on_mouse_entered")
	#connect("mouse_exited", self, "_on_mouse_exited")
	
	var texture
	if type in Global.entity_data.keys():
		texture = load("res://arts/resources/%s.png" % type)
	else:
		texture = load("res://arts/culpits/%s.png" % type)
	
	if buildable:
		#set_collision_layer_bit(3, true)
		set_collision_layer_bit(0, true)
	
	$Resource.set_texture(texture)


func set_wearing(value):
	wearing = value
	# if player is weearing this, it shouldn't be interactable or collision
	if wearing:
		set_collision_layer_bit(6, false)
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(3, false)
		set_collision_mask_bit(6, false)
		
	else:
		set_collision_layer_bit(6, true)
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(3, true)
		set_collision_mask_bit(6, true)


func get_hint_text():
	return "Pick Up %s" % type.capitalize()
	

func build_entity(base):
	if buildable:
		var builder = load("res://objects/buildings/Prebuild.tscn").instance()
		builder.type = type
		builder.data = data
		builder.card = self
		builder.directbuild = true
		get_tree().get_current_scene().get_node("Node2D").add_child(builder)
		builder.set_global_position(get_global_position())
		if not builder.check_blocked():
			builder.finish_build(base)
		else:
			cancel_build_entity()


func cancel_build_entity():
	buildable = false
	set_collision_layer_bit(3, false)
	set_collision_layer_bit(0, false)


func check_base():
	var temp_base = get_world_2d().get_direct_space_state().intersect_point(get_global_position(), 2 ,[],2,true,false)
	if not temp_base.empty():
		temp_base=temp_base[0].collider
		build_entity(temp_base)

	else:
		temp_base = get_tree().get_current_scene().get_node("Node2D")
		if buildable == true:
			cancel_build_entity()
	if not buildable:
		Global.player.reparent(self,temp_base)
	

func _process(delta):
	if throwing:
		velocity = lerp(velocity, Vector2.ZERO, 0.05)
		if velocity.length()<10:
			velocity = Vector2.ZERO
			throwing = false
			check_base()
			set_collision_mask_bit(6, true)
		move_and_slide(velocity)
	pass
	
	# if player is in range, magnet over there
	#if get_global_position().distance_to(Global.player.get_global_position()) < SNAP_RANGE:
	#	#set_global_position(get_global_position().linear_interpolate(Global.player.get_global_position(), 10 * delta))
	#	move_and_collide(get_global_position().direction_to(Global.player.get_global_position()), false)


func _on_mouse_entered():
	Global.player.mouse_select_culpit = self


# for entity, interact picks them up
func initial_control(player):
	if not wearing:
		if player.add_storage_object(type, data):
			
			$CollisionShape2D.set_deferred("disabled", true)
			
			magenet_to_delete(player)


func stop_control(player):
	pass


func throw(player,_throw = false, force = 1000):
	#check_base()
	set_wearing(false)
	stop_control(player)
	if _throw:
		velocity = player.get_facing().normalized() * force
	throwing = true
	set_collision_mask_bit(6, false)
	


func operate(player):
	print(type + "Being Used")


func magenet_to_delete(actor):
	$CollisionShape2D.set_deferred("disabled", true)
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", actor.get_global_position(), 0.1)
	yield(tween, "finished")
	
	actor.get_node("Sounds/Entity").play()
	queue_free()


func apply_magenet():
	pass


func get_data():
	return data


func on_select():
	#$AnimationPlayer.play("hover")
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Resource, "scale", Vector2(1, 1), 0.1)


func on_deselect():
	#$AnimationPlayer.play_backwards("hover")
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Resource, "scale", Vector2(0.7, 0.7), 0.1)


func on_in_range():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Resource, "scale", Vector2(0.76, 0.76), 0.1)
	tween.parallel().tween_property($Resource, "modulate", Color("ffffff"), 0.1)


func on_out_range():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Resource, "scale", Vector2(0.7, 0.7), 0.1)
	tween.parallel().tween_property($Resource, "modulate", Color("a9a9a9"), 0.1)


func powered():
	pass


func unpowered():
	pass
