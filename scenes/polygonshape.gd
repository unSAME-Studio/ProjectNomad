extends "res://objects/object_base.gd"


func _ready():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	
	$Shadow.polygon = $Polygon2D.polygon
	#$VisibilityEnabler2D.set_rect($Polygon2D.)
