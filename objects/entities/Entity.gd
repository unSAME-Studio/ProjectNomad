extends KinematicBody2D

class_name Entity

const SNAP_RANGE = 300

export(String) var type = "nano"
var action = true
var wearing = false

var throwing = false
var velocity = Vector2.ZERO

func _ready():
	var texture
	if type in Global.entity_data.keys():
		texture = load("res://arts/resources/%s.png" % type)
	else:
		texture = load("res://arts/culpits/%s.png" % type)
	
	$Resource.set_texture(texture)


func set_wearing(value):
	wearing = value
	# if player is weearing this, it shouldn't be interactable or collision
	if wearing:
		set_collision_layer_bit(6, false)
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(3, false)
		set_collision_mask_bit(6, false)
		
		$Card.hide()
		$Light2D.hide()
	else:
		set_collision_layer_bit(6, true)
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(3, true)
		set_collision_mask_bit(6, true)
		
		$Card.show()
		$Light2D.show()


func get_hint_text():
	return "Pick Up"


func check_base():
	var temp_base = get_world_2d().get_direct_space_state().intersect_point(get_global_position(), 2 ,[],2,true,false)
	if not temp_base.empty():
		temp_base=temp_base[0].collider
	else:
		temp_base = get_tree().get_current_scene().get_node("Node2D")
	
	Global.player.reparent(self,temp_base)
	

func _process(delta):
	if throwing:
		velocity = lerp(velocity, Vector2.ZERO, 0.05)
		if velocity.length()<10:
			velocity = Vector2.ZERO
			throwing = false
			check_base()
		move_and_slide(velocity)
	pass
	
	# if player is in range, magnet over there
	#if get_global_position().distance_to(Global.player.get_global_position()) < SNAP_RANGE:
	#	#set_global_position(get_global_position().linear_interpolate(Global.player.get_global_position(), 10 * delta))
	#	move_and_collide(get_global_position().direction_to(Global.player.get_global_position()), false)


# for entity, interact picks them up
func initial_control(player):
	if not wearing:
		if player.add_storage_object(type):
			queue_free()


func stop_control(player):
	pass


func throw(player):
	check_base()
	set_wearing(false)
	stop_control(player)
	velocity = player.get_facing().normalized() * 1000
	throwing = true


func operate(player):
	print(type + "Being Used")
