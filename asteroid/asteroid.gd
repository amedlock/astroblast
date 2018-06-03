extends Node2D

var is_large = false
var points = 50 

var  rot_speed = 3 ;
var  fall_speed = 60;
var  drift = 0
onready var sprite = find_node("Sprite")

var expl = preload("res://explosion/explosion.tscn")
var small 


func _ready():
	self.add_to_group("rocks")
	if is_large==true:
		small = load("res://asteroid/small.tscn")
		points = 10
	else:
		points = 20
	rot_speed = rand_range(1, 6)
	if randf() > 0.5: 
		rot_speed = -rot_speed
	self.fall_speed = rand_range(1,5) * 15
		

func _process(delta):
	sprite.rotate( delta * rot_speed )
	self.position.y += ( fall_speed * delta )
	if drift:
		self.position.x += ( drift * delta )
	if self.position.x < 20 or self.position.x > 780:
		self.queue_free()
	elif self.position.y >=390:
		self.get_parent().hit_ground( self )
		self.queue_free()		

func spawn():
	var offset = Vector2( 15, 0 )
	var d1 = rand_range( 45, 65 ) 
	var d2 = -d1 
	if self.position.x > 300:
		d1 = d1  * 0.2
	elif self.position.x < 100:
		d2 = d2 * 0.2
	var s1 = small.instance()
	s1.position = self.position - offset
	s1.drift = d1
	s1.fall_speed = self.fall_speed * 1.1
	s1.modulate = get_parent().random_color()
	self.get_parent().add_child( s1 )
	var s2 = small.instance()
	s2.drift = d2
	s2.fall_speed = s1.fall_speed
	s2.modulate = get_parent().random_color()
	s2.position = self.position + offset
	self.get_parent().add_child( s2 )
	

func explosion():
	var e = expl.instance()
	e.position = self.position
	get_parent().add_child( e )

func shot():
	self.explosion()
	get_parent().destroyed( self )
	if self.is_large:
		self.spawn();		
	self.queue_free()
	
	
func hit_ground():
	get_parent().hit_ground( self )	
	
	