extends "../base_enemy.gd"

signal landed;

var rspeed = 2;
var speed = 50;

onready var sprite = get_node("Sprite")


func _process(delta):
	self.position.y += (speed * delta)
	sprite.rotate( rspeed * delta )
	if self.position.y > 390:
		self.emit_signal( "landed" )
	

func shot():
	self.emit_signal( "destroyed" )
	self.explosion()
	self.queue_free()