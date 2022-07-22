extends Node2D


func damage(dealer, value):
	get_parent().damage(dealer, value)


func heal(dealer, value):
	get_parent().heal(dealer, value)
