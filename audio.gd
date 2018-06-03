extends AudioStreamPlayer2D


var bg_time = 0.9
var timer 


func _ready():
	stream = load("res://sounds/bgm.wav")
	volume_db = -9
	timer = bg_time

func stop():
	if self.playing:
		self.stop()
	set_process(false)

func start():
	stream = load("res://sounds/bgm.wav")
	timer = bg_time	
	set_process(true)


func _process(delta):
	timer -= delta
	if timer <= 0:
		self.play()
		timer = bg_time
