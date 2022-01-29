extends KinematicBody2D

onready var Planets = get_node("../Planets")

enum {
	MOVE
	INVINCIBLE
}

var state = MOVE
var velocity = Vector2(0, -100)
var acceleration = Vector2.ZERO
var thrust = 100
var G = 200000
var has_collided

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

func move_state(delta):
	for i in range(Planets.get_child_count()):
		var Planet = Planets.get_child(i)
		velocity = velocity + acceleration(Planet.get_global_position(), get_global_position())*delta

	if Input.is_action_pressed("ui_accept"):
		rotation_degrees = atan2(velocity.x, -velocity.y)*180/PI
		velocity = velocity + velocity.normalized() * thrust * delta
	else:
		rotation_degrees = atan2(velocity.x, -velocity.y)*180/PI

	has_collided = move_and_collide(velocity * delta)
	
	if has_collided:
		queue_free()

func acceleration(pos1, pos2):
	var direction = pos1 - pos2
	var length = direction.length()
	var normal = direction.normalized()
	return normal*G/pow(length, 2)
