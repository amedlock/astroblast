extends Node2D

var laser = preload("res://player/laser.tscn")

signal died;

var pos = 400;
var left = false;
var right = false;
var speed = 400

var fire = false;
var delay = 0.4 ; 
var timeout = 0;

var autofire = false;

onready var game = get_parent()


var player_expl = preload("res://player/player_expl.tscn" )

func _ready():
	connect( "area_entered", self, "hit" )
	

func _input(event):
	if Input.is_key_pressed(KEY_ENTER):
		self.autofire = not self.autofire
	elif Input.is_key_pressed(KEY_F9):
		self.emit_signal("died")
		return
	elif event is InputEventKey:
		if event.is_action("left"):
			left = event.is_pressed()
		elif event.is_action("right"):
			right = event.is_pressed()
		elif event.is_action("fire") and timeout <=0:
			fire = true;

func _process(delta):
	if timeout > 0 :
		timeout = max( timeout - delta, 0 )
	if timeout==0 and (fire or autofire):
		fire = false;
		fire_laser();
	if left:
		pos -= (speed * delta)
	if right:
		pos += (speed * delta )
	pos = clamp( pos, 30, 770 );
	self.position.x = self.pos 	


func fire_laser():
	var beam = laser.instance()
	self.get_parent().add_child( beam )
	beam.position = self.global_position - Vector2(0, 20)
	timeout = 0.45 - ( game.level * 0.05 )
	
	
func hit( obj ):
	self.emit_signal("died")

	
	
	