extends Node2D


var points = 100

signal destroyed  # when shot by player


func explosion():
	var e = load("res://explosion/explosion.tscn").instance()
	e.position = self.position
	get_parent().add_child( e )
	get_parent().hit_sound()
	

  