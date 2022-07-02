extends Area2D

var base = null
var build_points = []
var active = true
var snappoint


func _ready():
	snappoint = $snappoint
	if active == true:
		active(get_parent().get_parent())
	else:
		set_modulate(Color('48ffffff'))


func active(_base):
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	set_modulate(Color('ffffffff'))
	base = _base
	base.rooms.append(self)
	build_points = $structures/points.get_children()
	for i in build_points:
		i.room = self

# will return the base
func get_build():
	print(base)
	return base
	
func get_build_points(type):
	var out_points = []
	for i in $structures/points.get_children():
		if i.type == type:
			out_points.append(i)
	if type == 'Wall':
		for i in $structures.get_children():
			if i.name != 'points':
				out_points.append(i)
	return out_points
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
