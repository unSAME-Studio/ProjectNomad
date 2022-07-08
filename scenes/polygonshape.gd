extends "res://objects/object_base.gd"


func _ready():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
