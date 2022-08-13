extends Culpit


var controlling = false

var bullet = preload("res://objects/weapons/bullet.tscn")


var damage = 6
var projectile_speed = 5

var rate = 0.05
var cd = 10
var cooldown_comp = preload("res://systems/CooldownComponent.tscn")
var cooldown
var cd_speed = 20


func _ready():
	var p = Position2D.new()
	$Sprite.add_child(p)
	p.set_name("Position2D")
	p.set_position(Vector2(10, 0))
	
	cooldown = cooldown_comp.instance()
	add_child(cooldown)
	cooldown.set_name("CooldownComponent")
	cooldown.speed = cd_speed


func _process(delta):
	if controlling and not wearing:
		$Sprite.look_at(get_global_mouse_position())

func apply_buff(buff):
		if 'recharge_boost' in buff:
			cooldown.speed = cd_speed * buff.recharge_boost

func operate(player):
	if cooldown.can_fire(cd):
		print("FIRE!!!")
		var b = bullet.instance()
		if slotted:
			b.damage = damage * slotted.damage_buff
			b.speed = projectile_speed*slotted.speed_buff
			b.scale = scale
		b.parent = self
		b.set_global_position($Sprite/Position2D.get_global_position())
		b.set_global_rotation($Sprite.get_global_rotation())
		get_tree().get_current_scene().get_node("Node2D").add_child(b)
		
		cooldown.increase_cooldown(cd)
		
		$Anim.play("fire")



func initial_control(body):
	controlling = true
	user = body
	print(name + " is being controller")
	if slotted:
		if 'cd_multiplyer' in slotted:
			cd = cd*slotted.cd_multiplyer
	if not wearing:
		snap_position(body)


func stop_control(_body):
	user = self
	#body.camera.camera.set_zoom(Vector2(1,1))
	
	controlling = false
	print("stopping " + name + " from controlling")
