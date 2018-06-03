extends Node2D

onready var game = get_parent()

# rocks are generated 1..RATE number each (T/2 .. T) seconds
var rate = 1.5 ;
var secs = 3 ;

var next = 0 ;  # number of rocks each 2 seconds


var small_rock = preload("res://asteroid/small.tscn")
var large_rock = preload("res://asteroid/large.tscn")

onready var audio = get_node("sfx")

func _ready():
	self.set_process(false)

	
func random_color():
	var r1 = rand_range(0.2, 0.9)
	var r2 = 1.0 - r1
	var r3 = min(r1, r2 ) + abs( r2 - r1 ) / 2 
	var t = (randi() % 3)
	if t==0:
		return Color( r1, r2, r3 )
	elif t==1:
		return Color( r2, r3, r1 )
	else:
		return Color( r3, r1, r2 )
	

func _process(delta):
	if next > 0 :
		next -= delta;
	else:
		next = rand_range( secs / 2, secs )
		spawn_rocks()

func clear_all():
	for x in self.get_children():
		if x.is_in_group("rocks"):
			x.queue_free()


func hit_ground( r ):
	game.dec_score( r )


func destroyed( r ):
	game.inc_score( r )
	audio.stream = load("res://sounds/hit.wav")
	audio.play()


func spawn_rock(t, big):
	var a = t.instance()
	a.is_large = big
	a.position = Vector2( rand_range(50, 750), 20 )
	a.modulate = random_color()
	a.rot_speed = rand_range(2,8 )
	self.add_child( a )
	return a


func spawn_rocks():
	var c = rand_range( 1,  rate )
	while c >0:
		if ( randi() % 3 )==1:
			spawn_rock(large_rock, true)
			c -= 2
		else:
			spawn_rock(small_rock, false)
			c -=1 
	