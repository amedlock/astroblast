extends "../base_enemy.gd"

var speed = 100
var move_left = false

var bomb_prefab = preload("res://enemies/ufo/bomb.tscn")
var bomb 

var game ;  # set by enemies.gd script

func _ready():
	if move_left: 
		position.x = 795
	else: 
		position.x = 5
	self.points = 100

func _process(delta):
	if move_left:
		position.x -= (speed * delta)
		if position.x < 10:
			self.queue_free()
			return
	else:
		position.x += (speed * delta)
		if position.x > 790:
			self.queue_free()
			return
	if bomb==null and game.gun!=null:
		var dist = abs( game.gun.position.x - self.position.x )
		if dist < 20:
			drop_bomb()
		
		
func drop_bomb():
	bomb = bomb_prefab.instance()
	bomb.position = self.position + Vector2(0,7)
	get_parent().add_child( bomb )
	bomb.connect("tree_exited", self, "next_bomb" )
	
func next_bomb():
	bomb = null
	
func shot():
	if bomb!=null: bomb.queue_free()
	var e = load("res://explosion/explosion.tscn").instance()
	e.position = self.position
	get_parent().add_child( e )
	self.queue_free()