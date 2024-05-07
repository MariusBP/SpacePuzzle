extends StaticBody2D

@onready var PlanetGrey = $PlanetGrey
var rng = RandomNumberGenerator.new()

func _ready():
	rng.seed = randi()
	PlanetGrey.set_rotation_degrees(rng.randi_range(0, 360))
