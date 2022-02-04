extends KinematicBody2D

onready var Planets = get_node("../Planets")
onready var PlanetStart = get_node("../Planets/PlanetStart")

enum {
	LAUNCH
	MOVE
	LANDED
}

var state = LAUNCH
var velocity = Vector2.ZERO
var launch_velocity = 100
var thrust = 100
var G = 200000
var has_collided
var anchor_position

func _ready():
	anchor_position = PlanetStart.global_position
	set_global_position(PlanetStart.global_position)

func _physics_process(delta):
	match state:
		LAUNCH:
			launch_state(delta)
		MOVE:
			move_state(delta)

func launch_state(_delta):
	look_at(get_global_mouse_position())
	set_global_position((anchor_position + Vector2(23, 0).rotated(rotation)))
	if Input.is_action_pressed("ui_accept"):
		velocity = launch_velocity*Vector2(1,0).rotated(rotation)
		state = MOVE

func move_state(delta):
	for i in range(Planets.get_child_count()):
		var Planet = Planets.get_child(i)
		velocity = velocity + acceleration(Planet.get_global_position(), get_global_position())*delta

	if Input.is_action_pressed("ui_accept"):
		rotation = velocity.angle()
		velocity = velocity + velocity.normalized() * thrust * delta
	else:
		rotation = velocity.angle()

	has_collided = move_and_collide(velocity * delta)

func acceleration(pos1, pos2):
	var direction = pos1 - pos2
	var length = direction.length()
	var normal = direction.normalized()
	return normal*G/pow(length, 2)
