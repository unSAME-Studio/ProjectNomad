extends StaticBody2D


func _ready():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	$LightOccluder2D.occluder.set_polygon($Polygon2D.polygon)



