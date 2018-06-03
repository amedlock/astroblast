extends Node2D

onready var game = get_parent()

var next_spinner 
var spinner

var ufo
var next_ufo

var missile
var next_missile

var lg_spinner = preload("res://enemies/spinner/large_spinner.tscn")
var sm_spinner = preload("res://enemies/spinner/small_spinner.tscn")

var missile_prefab = preload("res://enemies/guided/guided.tscn")
var ufo_prefab = preload("res://enemies/ufo/ufo_t.tscn")


onready var audio = get_node("sfx")

func _ready():
	next_spinner = rand_range( 2, 6 )
	next_missile = rand_range( 12, 30 )
	next_ufo = rand_range( 20, 40 )
	self.set_process(false)

func clear_all():
	next_spinner = rand_range( 2, 6 ) + 1
	for x in self.get_children():
		if x != audio:
			x.queue_free()

func _input(event):
	if Input.is_key_pressed(KEY_F5):
		self.next_spinner = 0
	if Input.is_key_pressed(KEY_F6):
		self.next_missile = 0	
	if Input.is_key_pressed(KEY_F7):
		self.next_ufo = 0	

func _process(delta):
	if spinner==null:
		next_spinner -= delta
		if next_spinner <= 0:
			spawn_spinner()
	if missile==null and game.level > 1:
		self.next_missile -= delta
		if self.next_missile <= 0:
			spawn_missle()
	if ufo==null and game.level > 4:
		self.next_ufo -= delta
		if self.next_ufo <= 0:
			spawn_ufo()		


func spawn_spinner():
	if (randi() % 2) == 1:
		spinner = sm_spinner.instance()
		spinner.rspeed = 5
		spinner.speed = 80
		spinner.points = 80
	else:
		spinner = lg_spinner.instance()
		spinner.rspeed = 3
		spinner.speed = 40
		spinner.points = 40
	spinner.position = Vector2( rand_range(100, 700), 5 )
	spinner.connect("landed", self, "spinner_hit")
	spinner.connect("destroyed", game, "inc_score", [spinner] )
	spinner.connect("tree_exited", self, "next_spinner" )
	self.add_child( spinner )

func spawn_missle():
	missile = missile_prefab.instance()
	missile.game = self.game
	missile.position = Vector2( rand_range(100, 700), 5 )
	missile.connect("destroyed", game, "inc_score", [missile] )
	missile.connect("tree_exited", self, "next_missile" )
	self.add_child( missile )

func spawn_ufo():
	ufo = ufo_prefab.instance()
	ufo.game = self.game
	if randi() % 2 == 1: 
		ufo.move_left = true
	ufo.position = Vector2( rand_range(100, 700), 20 )
	ufo.connect("destroyed", game, "inc_score", [ufo] )
	ufo.connect("tree_exited", self, "next_ufo" )
	self.add_child( ufo )


func next_spinner():
	spinner = null
	next_spinner = rand_range( 5, 10 )	


func next_missile():
	missile = null
	next_missile = rand_range( 15, 30 )	

func next_ufo():
	ufo = null
	next_ufo = rand_range( 20, 40 )	
	

func spinner_hit():
	game.destroy_gun()
	
func hit_sound():
	audio.stream = load("res://sounds/hit.wav")
	audio.play()
	