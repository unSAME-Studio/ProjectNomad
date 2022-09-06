extends StaticBody2D


func _ready():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	$LightOccluder2D.occluder.polygon = $Polygon2D.polygon
	$CollisionPolygon2D.set_global_transform($Polygon2D.get_global_transform())
	$LightOccluder2D.set_global_transform($Polygon2D.get_global_transform())
