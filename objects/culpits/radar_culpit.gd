extends Culpit


var enabled = false
var current_bodies
var cd = false

var target_list = []
var indi_list = {}

var indicator = preload("res://objects/VFX/indi.tscn")

export var points_to = Vector2(5580, -7500)

func _process(delta):
	$radar/Sprite.set_global_rotation(0)
	$radar/Scan.rotate(-4 * delta)
	
	$Sprite.rotate(-4 * delta)
	if enabled:
		if points_to:
			$radar/arrow.look_at(points_to)
		#$radar/indi.look_at(Global.player.get_global_position())
		for i in target_list:
			if is_instance_valid(i):
				if get_global_position().distance_to(i.get_global_position()) < 3600:
					indi_list[i].show()
					indi_list[i].look_at(i.get_global_position())
				else:
					indi_list[i].hide()
				
#		# check for differences
#		if current_bodies != $DetectionArea.get_overlapping_bodies():
#			print("|||||||     Update bodies generator")
#			current_bodies = $DetectionArea.get_overlapping_bodies()
#
#		#print($DetectionArea.get_overlapping_bodies())
#		for i in $DetectionArea.get_overlapping_bodies():
#			i.powered()



func operate(player):
	enabled = !enabled
	if enabled:
		$Particles2D.set_emitting(true)
		$DetectionArea.set_position(Vector2.ZERO)
		if not $DetectionArea.get_overlapping_bodies().empty():
			for i in $DetectionArea.get_overlapping_bodies():
				if 'type' in i:
					if i.type == 'compass':
						points_to = i.points_to
						$radar/arrow.show()
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		#tween.tween_property($Sprite2, "modulate", Color("c6ffce"), 0.3)
		tween.tween_property($radar, "scale", Vector2(1, 1), 0.3)
		for i in get_tree().get_current_scene().get_node("Node2D").get_children():
			#if i.get_class():
			#	target_list = []
			if i.get_class() == 'RigidBody2D':
				if not i in target_list and i != base:
					target_list.append(i)
					var indi = indicator.instance()
					indi_list[i] = indi
					$radar.add_child(indi)
					if not 'faction' in i:
						indi.modulate = Color('cc2104')
					else:
						if i.faction == 'environment':
							indi.modulate = Color('494893')
							indi.get_node("Sprite").scale = Vector2(0.3,0.3)
						if i.faction == 'armour':
							indi.modulate = Color('60e370')
					indi.hide()
	else:
		$radar/arrow.show()
		$Particles2D.set_emitting(false)
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		#tween.tween_property($Sprite2, "modulate", Color("c6ffce"), 0.3)
		tween.tween_property($radar, "scale", Vector2(0,0), 0.3)



func _on_DetectionArea_body_entered(body):
	pass
	
	#if enabled:
	#	body.powered()


func _on_DetectionArea_body_exited(body):
	pass
