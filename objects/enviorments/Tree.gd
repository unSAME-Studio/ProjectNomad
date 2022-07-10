extends StaticBody2D


func _ready():
	set_rotation_degrees(rand_range(0, 360))
	
	$Branch.set_texture(load("res://arts/enviroment/tree_branch_%d.png" % round(rand_range(1, 2))))
	$Branch.set_rotation_degrees(rand_range(0, 360))
	
	for i in $Branch.get_children():
		# random hiding
		if randi() & 1:
			i.hide()
			continue
		
		# random rotation
		i.set_rotation_degrees(rand_range(0, 360))
