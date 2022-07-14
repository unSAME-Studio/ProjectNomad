extends "res://objects/object_base.gd"


var tree = preload("res://objects/enviorments/Tree.tscn")
var entity = preload("res://objects/entities/Entity.tscn")


func _ready():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	
	$Shadow.polygon = $Polygon2D.polygon
	#$VisibilityEnabler2D.set_rect($Polygon2D.)
	
	
	return
	
	# generate a bunch of trees
	for i in range(randi() % 5):
		var t = tree.instancce()
		$entity.add_child(t)
		
		var pos = Vector2.ZERO
		while not Geometry.is_point_in_polygon(pos, $Polygon2D.get_polygon()):
			pos = Vector2.ZERO
		
