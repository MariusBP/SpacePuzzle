extends KinematicBody2D

onready var Planets = get_node("../Planets")
onready var PlanetStart = get_node("../Planets/PlanetStart")
onready var LaunchPower = get_node("../GUI/VContainer/Bars/LaunchPower")
onready var FuelGauge = get_node("../GUI/VContainer/Bars/FuelGauge")
onready var Timer = get_node("Timer")
onready var AnimationState = $AnimationTree.get("parameters/playback")

enum {
	LAUNCH
	MOVE
	DRIFTING
	LANDED
}

var state = LAUNCH

func _ready():
	var _no_fuel_error = Stats.connect("no_fuel", self, "_on_no_fuel")
	Stats.anchor_position = PlanetStart.global_position
	set_global_position(PlanetStart.global_position)
	AnimationState.travel("idle")

func _physics_process(delta):
	match state:
		LAUNCH:
			launch_state(delta)
		MOVE:
			move_state(delta)
		DRIFTING:
			drifting_state(delta)

func launch_state(_delta):
	if (get_global_mouse_position().distance_to(global_position)) > 35:
		look_at(get_global_mouse_position())
	set_global_position((Stats.anchor_position + Vector2(23, 0).rotated(rotation)))
	if Stats.powering_up:
		LaunchPower.value += Stats.launch_power_delta
		if LaunchPower.value >= Stats.launch_power_max:
			Stats.powering_up = false
	else:
		LaunchPower.value -= Stats.launch_power_delta
		if LaunchPower.value <= 0:
			Stats.powering_up = true
	if Input.is_action_pressed("boost"):
		Stats.velocity = (LaunchPower.value+Stats.base_launch_power)*Vector2(1,0).rotated(rotation)
		LaunchPower.visible = false
		FuelGauge.visible = true
		state = DRIFTING
		Timer.start(Stats.boost_pause_on_launch)

func move_state(delta):
	for i in range(Planets.get_child_count()):
		var Planet = Planets.get_child(i)
		Stats.velocity = Stats.velocity + acceleration(Planet.get_global_position(), get_global_position())*delta

	rotation = Stats.velocity.angle()
	
	if Input.is_action_pressed("boost"):
		AnimationState.travel("boost")
		Stats.velocity = Stats.velocity + Stats.velocity.normalized() * Stats.thrust * delta
		Stats.fuel -= Stats.fuel_drain*delta
	elif Input.is_action_pressed("break"):
		AnimationState.travel("idle")
		Stats.velocity = Stats.velocity - 0.9*Stats.velocity.normalized() * Stats.thrust * delta
		Stats.fuel -= Stats.fuel_drain*0.9*delta
	else:
		AnimationState.travel("idle")

	Stats.has_collided = move_and_collide(Stats.velocity * delta)

func drifting_state(delta):
	for i in range(Planets.get_child_count()):
		var Planet = Planets.get_child(i)
		Stats.velocity = Stats.velocity + acceleration(Planet.get_global_position(), get_global_position())*delta

	rotation = Stats.velocity.angle()

	Stats.has_collided = move_and_collide(Stats.velocity * delta)

func acceleration(pos1, pos2):
	var direction = pos1 - pos2
	var length = direction.length()
	var normal = direction.normalized()
	return normal*Stats.G/pow(length, 2)


func _on_no_fuel():
	state = DRIFTING

func _on_VisibilityNotifier2D_screen_exited():
	pass


func _on_VisibilityNotifier2D_screen_entered():
	pass


func _on_Timer_timeout():
	#Timer added to avoid instant fuel drain. Prevents boost or brake for "Stats.boost_pause_on_launch" amount of time
	state = MOVE
