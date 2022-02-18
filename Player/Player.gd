extends KinematicBody2D

onready var Planets = get_node("../Planets")
onready var PlanetStart = get_node("../Planets/PlanetStart")
onready var LaunchPower = get_node("../GUI/VContainer/Bars/LaunchPower")

enum {
	LAUNCH
	MOVE
	LANDED
}

var state = LAUNCH

func _ready():
	Stats.anchor_position = PlanetStart.global_position
	set_global_position(PlanetStart.global_position)

func _physics_process(delta):
	match state:
		LAUNCH:
			launch_state(delta)
		MOVE:
			move_state(delta)

func launch_state(_delta):
	look_at(get_global_mouse_position())
	set_global_position((Stats.anchor_position + Vector2(23, 0).rotated(rotation)))
	if Stats.powering_up:
		LaunchPower.value += 1
		if LaunchPower.value >= 100:
			Stats.powering_up = false
	else:
		LaunchPower.value -= 1
		if LaunchPower.value <= 0:
			Stats.powering_up = true
	if Input.is_action_pressed("ui_accept"):
		Stats.velocity = LaunchPower.value*Vector2(1,0).rotated(rotation)
		LaunchPower.visible = false
		state = MOVE

func move_state(delta):
	for i in range(Planets.get_child_count()):
		var Planet = Planets.get_child(i)
		Stats.velocity = Stats.velocity + acceleration(Planet.get_global_position(), get_global_position())*delta

	if Input.is_action_pressed("ui_accept"):
		rotation = Stats.velocity.angle()
		Stats.velocity = Stats.velocity + Stats.velocity.normalized() * Stats.thrust * delta
	else:
		rotation = Stats.velocity.angle()

	Stats.has_collided = move_and_collide(Stats.velocity * delta)

func acceleration(pos1, pos2):
	var direction = pos1 - pos2
	var length = direction.length()
	var normal = direction.normalized()
	return normal*Stats.G/pow(length, 2)
