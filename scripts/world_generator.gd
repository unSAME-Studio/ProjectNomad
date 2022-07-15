extends Node2D


var island = preload("res://objects/enviorments/Island.tscn")


func _ready():
	for i in range(15):
		var p = island.instance()
		get_parent().call_deferred("add_child", p)
		
		p.set_global_position(Vector2(rand_range(-10000, 10000), rand_range(-10000, 10000)))
