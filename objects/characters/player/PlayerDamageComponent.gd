extends Node2D


func damage(value):
	get_parent().damage(value)


func heal(value):
	get_parent().heal(value)
