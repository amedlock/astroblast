extends Node2D


class LevelInfo:
	var max_score = 0
	var color = Color(0,0,0)
	
func mk_level( sc, col_str ):
	var r = LevelInfo.new()
	r.max_score = sc
	r.color = Color( col_str )
	return r


var level_info = [
	null, # no level zero, Dijkstra 
	mk_level( 999, "#000000" ),
	mk_level( 4999, "#414a74" ), # blue
	mk_level( 19999, "#8574b5" ), #purple	
	mk_level( 39999, "#489890" ), #turquose
	mk_level( 79999, "#9f4f60" ), #red
	mk_level( 149999, "#3c914e" ), # green
	mk_level( 199999, "#414141" ), # grey
	mk_level( 999999, "#000000" )
	#mk_level( 99999, "#b79564" ), #orange
	#mk_level( 99999, "#b8b373" ), #brown
];
	

var current = null

var level = 1
var score = 0
var ships = 6


onready var rocks = find_node("rocks")
onready var enemies = find_node("enemies")
onready var audio = find_node("audio_beat")

var player = preload("res://player/player.tscn")
var gun = null
onready var timer = get_node("spawn")

var player_expl = preload("res://player/player_expl.tscn")


onready var score_ui = get_node("hud/score")
onready var lives_ui = get_node("hud/lives")
onready var game_over_ui = get_node("hud/game_over")
onready var space = get_node("bg/space")

func _ready():
	randomize()
	current = level_info[1]
	space.modulate = current.color 
	level = 1
	timer.connect( "timeout", self, "spawn_player" )
	timer.start()

func _input(event):
	if Input.is_key_pressed( KEY_F4 ):
		self.score += 500
	elif Input.is_key_pressed( KEY_F10 ):
		self.get_tree().quit()

func _process(delta):
	score_ui.text = str(self.score )
	lives_ui.text = "X" + str(ships)
	var max_level = len(level_info)-1
	if score >= current.max_score and level < max_level:
		level += 1
		current= level_info[level]
		space.modulate = current.color 
	



func spawn_player():
	gun = player.instance()
	self.add_child( gun )	
	gun.position = Vector2(400, 385)
	gun.connect("died", self, "destroy_gun")
	rocks.set_process( true )
	enemies.set_process( true )
	audio.set_process(true)


func destroy_gun():
	if gun==null: 
		print("Cant free empty gun")
		return
	rocks.clear_all()
	rocks.set_process( false )
	enemies.clear_all()
	enemies.set_process( false )
	var pe = player_expl.instance()
	self.add_child( pe )
	pe.position = gun.position
	pe.visible = true
	audio.set_process(false)
	gun.queue_free()
	gun=null	
	ships-= 1
	if ships>0:
		self.timer.wait_time = 1.5
		self.timer.start()
	else:
		game_over()
	

func game_over():
	game_over_ui.show()
	audio.set_process(false)


func inc_score( r ):
	score += r.points


func dec_score( r ):
	score -= r.points
	
