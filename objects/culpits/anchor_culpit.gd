extends Culpit


var running = false
var targeting = false
var on_cd = false

func _ready():
	pass


func _process(delta):
	if running and base:
		if base.has_method("brake"):
			base.brake()

func get_hint_text():
	if running:
		return 'Release Ship'
	else:
		return 'Anchor Ship'

func operate(player):
	running = !running
			

func _on_Timer_timeout():
	on_cd = false
	
