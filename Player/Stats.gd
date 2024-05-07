extends Node

signal no_fuel

@export var max_fuel = 100: set = set_max_fuel
@export var fuel = max_fuel: set = set_fuel

@export var velocity = Vector2.ZERO
@export var launch_velocity = 0
@export var base_launch_power = 50
@export var powering_up = true
@export var launch_power_max: int = 200
@export var launch_power_delta: int = launch_power_max/100
@export var thrust = 100
@export var G = 200000
@export var fuel_drain = 50
@export var boost_pause_on_launch = 0.3
var has_collided
var anchor_position

func set_max_fuel(value):
	max_fuel = max(value, 1)

func set_fuel(value):
	fuel = clamp(value, 0, max_fuel)
	if fuel <= 0:
		emit_signal("no_fuel")
