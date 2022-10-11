extends Node


func _ready():
	pass

func _process(delta):
	$Control/CenterContainer/VBoxContainer/Label.set_text("You Died! Respawning in %d seconds." % ($Timer.get_time_left() + 1))


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_Timer_timeout():
	_on_Button_pressed()
