extends KinematicBody2D

var bullet = preload("res://objects/weapons/bullet.tscn")

var user = self


func _ready():
	pass


func _physics_process(delta):
	$Enemy.look_at(Global.player.get_global_position())
	
	#move_and_slide(Vector2.RIGHT * delta * 20, Vector2.UP)


func _on_Timer_timeout():
	var b = bullet.instance()
	b.parent = self
	b.set_global_position($Enemy/Position2D.get_global_position())
	b.set_global_rotation($Enemy/Position2D.get_global_rotation())
	get_tree().get_current_scene().get_node("Node2D").add_child(b)


func _on_VisibilityEnabler2D_screen_entered():
	$Timer.start()


func _on_VisibilityEnabler2D_screen_exited():
	$Timer.stop()
