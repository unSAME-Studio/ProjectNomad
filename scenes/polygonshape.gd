extends "res://objects/object_base.gd"


var tree = preload("res://objects/enviorments/Tree.tscn")
var entity = preload("res://objects/entities/Entity.tscn")


func generate(polygon):
	$Polygon2D.polygon = polygon
	#$Polygon2D.color = Color(randf(), randf(), randf(), 0.6)
	$Shadow.polygon = polygon
	
	$CollisionPolygon2D.polygon = polygon
	#$VisibilityEnabler2D.set_rect($Polygon2D.)
	
	return 
	
	# generate a bunch of trees
	for i in range(randi() % 3):
		var t = tree.instance()
		$entity.add_child(t)
		
		var pos = Vector2.ZERO
		while not Geometry.is_point_in_polygon(pos, $Polygon2D.get_polygon()):
			pos = Vector2.ZERO
		
