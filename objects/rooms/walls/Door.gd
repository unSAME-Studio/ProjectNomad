extends Wall


func ready():
	polygon = $Polygon2D
#	$CollisionPolygon2D.polygon = $Polygon2D.polygon
#	$LightOccluder2D.occluder.set_polygon($Polygon2D.polygon)
	var point = load("res://objects/buildings/buildpoint.tscn").instance()
	point.type = 'door'
	add_child(point)
