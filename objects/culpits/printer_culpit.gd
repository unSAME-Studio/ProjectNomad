extends Culpit


var card_list = []

func _ready():
	pass

func initial_control(body):
	print(name + " is being controller")
	user = body
	
	$CanvasLayer/Control.show()


func stop_control(body):
	print("stopping " + name + " from controlling")
	user = null
	
	$CanvasLayer/Control.hide()


func operate(player):
	return 
	
	# currently only print when player is holding nano
	if player.consume_storage_object("nano"):
		
		# spawn card
		player.add_build_card(["wall", "room", "door wall"][randi() % 3])
