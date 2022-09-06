extends ScrollContainer

var cd
var actived = false
var tween


func _ready():
	set_visible(false)
	#rect_position = Vector2(44,400)
	pass



func active(active = !actived):
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	if active:
		set_visible(true)
		#rect_position = Vector2(44,400)
		actived = true
		tween.tween_property(self, "rect_position", Vector2(44,41), 0.2)
		tween.parallel().tween_property(self, "rect_scale", Vector2(1,1), 0.2)
	else:
		actived = false
		tween.tween_property(self, "rect_position", Vector2(44,400), 0.2)
		tween.parallel().tween_property(self, "rect_scale", Vector2(0.2,0.2), 0.2)
		#tween.tween_callback(self,'set_visible',[false])
