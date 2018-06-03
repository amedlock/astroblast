extends Node2D


func _ready():
	var anim = get_node("animation")
	anim.connect("animation_finished", self, "is_done" )
	anim.play("explode")

func is_done(n):
	self.visible = false
	self.queue_free()
