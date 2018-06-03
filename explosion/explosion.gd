extends Node2D


func _ready():
	self.scale = Vector2(0.5, 0.5 )
	var anim = find_node("animation")
	anim.connect( "animation_finished", self, "remove_me" )
	anim.play( "explode")


func remove_me( a ):
	self.queue_free()