extends Culpit


func initial_control(body):
	print(name + " is being controller")
	
	body.add_build_card(["wheel", "light", "printer", "locker"][randi() % 4])


func stop_control(body):
	print("stopping " + name + " from controlling")
