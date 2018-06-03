extends "../base_enemy.gd"


var speed = 200

func _ready():
	self.points = 50

func _process(delta):
	self.position.y += (speed * delta)
	if self.position.y>390:
		self.queue_free()


func shot():
	self.explosion()
	self.queue_free()
	self.emit_signal("destroyed")