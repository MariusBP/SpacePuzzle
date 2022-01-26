extends KinematicBody2D

onready var Planets = get_tree().get_nodes_in_group("Planets")

enum {
	MOVE
	INVINCIBLE
}

var state = MOVE
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var thrust = 100
var has_collided

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	print(Planets)
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		rotation_degrees = atan2(velocity.x, -velocity.y)*180/PI
		velocity = velocity + input_vector * thrust * delta

	has_collided = move_and_collide(velocity * delta)
	
	if has_collided:
		queue_free()
