extends Wall

var door_instance = preload("res://objects/rooms/walls/door_struct.tscn")
var point

func ready():
	polygon = $Polygon2Ds
	type = 'door wall'
#	$CollisionPolygon2D.polygon = $Polygon2D.polygon
#	$LightOccluder2D.occluder.set_polygon($Polygon2D.polygon)
	point = load("res://objects/buildings/buildpoint.tscn").instance()
	point.type = 'door wall'
	add_child(point)
	point.active = true

func spawn_door():
	if $structure.get_children().empty():
		var door_p = door_instance.instance()
		$structure.add_child(door_p)
	else:
		for i in $structure.get_children():
			i.queue_free()
func destroy():
	hide()
	$CollisionPolygon2D2.polygon = []
	$CollisionPolygon2D.polygon = []
	$LightOccluder2D.occluder.polygon = []
	$LightOccluder2D2.occluder.polygon = []
	for i in $structure.get_children():
		i.queue_free()
	point.active = true
	actived = false
	
func repair():
	show()
	$CollisionPolygon2D2.polygon = []
	$CollisionPolygon2D.polygon = []
	$LightOccluder2D.occluder.polygon = []
	$LightOccluder2D2.occluder.polygon = []	
	actived = true
