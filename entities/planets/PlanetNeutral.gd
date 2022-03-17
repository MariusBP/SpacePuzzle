extends StaticBody2D

onready var Sprite = $PlanetGrey
var rng = RandomNumberGenerator.new()

func _ready():
	rng.seed = randi()
	Sprite.set_rotation_degrees(rng.randi_range(0, 360))
