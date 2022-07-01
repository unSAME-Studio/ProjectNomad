extends Area2D

var base = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$structures/Wall/CollisionPolygon2D.polygon = $structures/Wall/Polygon2D.polygon
	$structures/Wall/LightOccluder2D.occluder.set_polygon($structures/Wall/Polygon2D.polygon)
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	base = get_parent().get_parent()
	
	#pass
#will return the base
func get_build():
	return base

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
