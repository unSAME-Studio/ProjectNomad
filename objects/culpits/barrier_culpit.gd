extends Culpit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var controlling = false
var deployed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	controllable = false
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(3, false)
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	$LightOccluder2D.occluder.polygon = $Polygon2D.polygon
	$CollisionPolygon2D.set_global_transform($Polygon2D.get_global_transform())
	$LightOccluder2D.set_global_transform($Polygon2D.get_global_transform())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not wearing and not deployed:
		#set_collision_layer_bit(0, true)
		set_collision_layer_bit(3, true)
		deployed = true
	if controlling and not wearing:
		look_at(get_global_mouse_position())

func initial_control(body):
	controlling = true
	user = body
	print(name + " is being controller")


func stop_control(_body):
	user = self
	#body.camera.camera.set_zoom(Vector2(1,1))
	
	controlling = false
	print("stopping " + name + " from controlling")

func _on_destroy():
	queue_free()
