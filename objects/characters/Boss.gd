extends "res://objects/object_base.gd"

export var speed = 200
#export var friction = 0.01
export var acceleration = 0.1

var controlling = false
var captain = null
var onboard = []

var leave = false

var steerforce = 1
var forwardforce = 1
var brakeforce = 1

var buffs = []
var buff_flag = false

var controlled = []
var controlled_sub = []

var speed_boost = 0
var recharge_boost = 1

var targetsList = []

var faction = 'ship'

var line

var operating = false
var heartNum = 2

func _ready():
	for i in get_children():
		if 'Fat' in i.name:
			heartNum += 1
			i.connect("tree_exiting", self, "heart_killed")
	$Node2D/FatBoy2.connect("tree_exiting", self, "heart_killed")
	$Node2D/FatBoy3.connect("tree_exiting", self, "heart_killed")
	#$RigidBody2D/PinJoint2D.connect_bodies(self,$RigidBody2D)
	# [TEMP DELETE]
	#$objects/Wall/CollisionPolygon2D.polygon = $objects/Wall/Polygon2D.polygon
	#$objects/Wall/LightOccluder2D.occluder.set_polygon($objects/Wall/Polygon2D.polygon)

func update_polygon(input,clip = false):
	pass
	
func heart_killed():
	heartNum -= 1
	if heartNum <=0:
		queue_free()
func handle_movement(direction):
		set_applied_torque(direction.x * 20000)		
		set_applied_force(Vector2(direction.x*50,direction.y * (300+speed_boost)).rotated(get_rotation()))
		var currvelocity = get_linear_velocity()
		var currrangular = get_angular_velocity()
		if currvelocity.length() > 300:
			set_linear_velocity(lerp(currvelocity, currvelocity.normalized()*300, 0.05))
			Global.player.camera.center_camera = true
		else:
			Global.player.camera.center_camera = false
			set_angular_velocity(lerp(currrangular,0.0, 0.01))
			if operating:
				operating = false
			if Input.is_action_pressed("ui_select"):
				set_linear_velocity(lerp(currvelocity, Vector2.ZERO, 0.05))
				set_angular_velocity(lerp(currrangular,0, 0.05))
			if Input.is_action_pressed("fire"):
				operate()
			if Input.is_action_pressed("utility"):
				operate(self,1)
		#velocity = move_and_slide(velocity)
func brake():
	set_linear_velocity(lerp(get_linear_velocity(), Vector2.ZERO, 0.02))
	set_angular_velocity(lerp(get_angular_velocity(),0, 0.02))
	
func enable_control(user):
	#sleeping = false
	controlling = true
	captain = user
	
func player_entered(player):
	onboard.append(player)

func player_leaved(player):
	onboard.erase(player)

func disable_control():
	captain.camera.align_camera()
	Global.player.camera.center_camera = false
	captain = null
	controlling = false
	leave = false
	set_applied_force(Vector2(0,0))
	set_applied_torque(0)		
	
func _process(delta):
	if not onboard.empty():
		if not captain:
			onboard[0].camera.align_camera()
	if not targetsList.empty():
		pass
#	if operating:
#		operating = false

func operate(player = self,group = 0):
	var targetGroup = group
	operating = true
	if targetGroup == 0:
		if not controlled.empty():
			for i in controlled:
				i.operate(player)
	else:
		if not controlled_sub.empty():
			for i in controlled_sub:
				i.operate(player)
				
func _physics_process(delta):
	if(controlling):
		var direction = get_input()
		handle_movement(direction)
		
			
func _integrate_forces(state):
	pass
	
func add_target(target):
	if target:
		if not target in targetsList:
			targetsList.append(target)
			target.connect("tree_exiting", self, "remove_target",[target])
			return true
	return false

func remove_target(target):
	if target in targetsList:
		#print('removing')
		targetsList.erase(target)
		target.disconnect("tree_exiting", self, "remove_target")
	
func get_targets(object):
	if not targetsList.empty():
		if targetsList[0]:
			return targetsList[0]
	return null
			

func add_buff(buff):
	if not buff in buffs:
		buffs.append(buff)
	apply_buff()

func remove_buff(buff):
	buffs.erase(buff)
	apply_buff()

func apply_buff():
	var speed_temp = 0
	var cd_temp = 1
	for i in buffs:
		if 'speed_boost' in i:
			speed_temp += i.speed_boost
		if 'recharge_boost' in i:
			cd_temp *= i.recharge_boost
	speed_boost = speed_temp
	recharge_boost = cd_temp
#	print('buff applied')
#	print("speed:% ,cd:%",[speed_boost,recharge_boost])
	for i in get_tree().get_nodes_in_group(name + "culpits"):
		if i.has_method('apply_buff'):
			i.apply_buff(self)
	
func get_build_points():
	var points = []
	if not rooms.empty():
		for i in rooms:
			points.append_array(i.get_build_points())
	return points
