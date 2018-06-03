extends Node2D

var speed = 500;

func _ready():
	connect("area_entered", self, "hit" )


func _process(delta):
	self.position.y -= (delta * speed)
	if self.position.y < 10:
		self.queue_free()


func hit( obj ):
	obj.shot()
	if not obj.is_in_group("rocks"):
		self.queue_free()
