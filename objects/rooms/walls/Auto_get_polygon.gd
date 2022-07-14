extends LightOccluder2D


func _ready():
	var parent = get_parent()
	if parent.has_method('get_polygon'):
		occluder = OccluderPolygon2D.new()
		occluder.set_polygon(parent.get_polygon())


