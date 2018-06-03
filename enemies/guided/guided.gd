extends "../base_enemy.gd"

onready var sprite = get_node("Sprite")

var game ;  # set by enemies.gd script

var fspeed = 75  # falling speed
var tspeed = 1.5  # track speed

var dodge_left = true

var anim_speed = 0.7
var anim = 0
var rot = 0.0
var size = 1.0
var rot_amount= 180


onready var audio = get_node("audio")
var audio_delay = 0.65;

func _ready():
	audio.stream = load("res://sounds/missile.wav")
	if (randi() % 2) == 1:
		dodge_left = false
	self.connect("area_entered", self, "hit" )
	self.points = 50
	if game==null: game = get_parent().get_parent().get_node("player")
	anim = anim_speed
	rot_amount = rand_range( 120, 180 )
	if randi() % 2 == 1:
		rot_amount = -rot_amount



func track_gun(delta):
	if game==null or game.gun==null:
		return
	var target = game.gun.position.x
	if position.y < 400:
		if dodge_left:
			target -= 40
		else:
			target += 40
	move_towards( target, delta )



func _process(delta):
	animate( delta )
	audio_delay -= delta
	if audio_delay<=0:
		audio.stream = load("res://sounds/missile.wav")
		audio.play()
		audio_delay = 0.65
	self.position.y += delta * fspeed 
	if self.position.y >=395:
		self.queue_free()
	track_gun( delta )
	
	
func animate(delta):
	anim = fmod( (anim + delta) , anim_speed )
	var ratio = anim / anim_speed 
	self.scale.x = size - ( 0.2 * ratio )
	self.scale.y = size - ( 0.2 * ratio )
	sprite.rotation_degrees = rot_amount * ratio	


func move_towards( xp, delta ):
	var diff = (xp - self.position.x )
	self.position.x += (diff * delta * tspeed)
	
func shot():
	self.explosion()
	self.queue_free()
	self.emit_signal("destroyed")

func hit(obj):
	if obj.is_in_group("rocks"):
		self.explosion()
		self.queue_free()
