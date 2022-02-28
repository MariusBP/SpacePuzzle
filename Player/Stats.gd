extends Node

export var max_fuel = 100 setget set_max_fuel
export onready var fuel = max_fuel setget set_fuel

export var velocity = Vector2.ZERO
export var launch_velocity = 0
export var base_launch_power = 50
export var powering_up = true
export(int) var launch_power_max = 200
export(int) var launch_power_delta = launch_power_max/100
export var thrust = 100
export var G = 200000
export var fuel_drain = 50
var has_collided
var anchor_position

signal no_fuel

func set_max_fuel(value):
	max_fuel = max(value, 1)

func set_fuel(value):
	fuel = clamp(value, 0, max_fuel)
	if fuel <= 0:
		emit_signal("no_fuel")
