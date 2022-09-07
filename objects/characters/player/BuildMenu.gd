extends ScrollContainer

var cd
var actived = false
var tween
var finished = true

func _ready():
	rect_position = Vector2(44,400)
	#modulate = Color(0,0,0,0)



func active(active = !actived):
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	if active:
		show()
		
		rect_position = Vector2(44,400)
		finished = false
		actived = true
		tween.tween_property(self, "rect_position", Vector2(44,400), 0.01)
		tween.tween_property(self, "rect_position", Vector2(44,41), 0.2)
		tween.parallel().tween_property(self, "rect_scale", Vector2(1,1), 0.2)
		#tween.parallel().tween_property(self, "module", Color(1,1,1,1), 0.2)
		tween.tween_callback(self,'set_finish',[true])
	else:
		actived = false
		finished = false
		tween.tween_property(self, "rect_position", Vector2(44,400), 0.2)
		tween.parallel().tween_property(self, "rect_scale", Vector2(0.2,0.2), 0.2)
		#tween.parallel().tween_property(self, "module", Color(0,0,0,0), 0.2)
		tween.tween_callback(self,'set_finish',[false])

func set_finish(type):
	if not type:
		hide()
	finished = true
	
#func _process(delta):
#	if finished:
#		if not actived:
#			hide()
#		if actived:
#			show()
