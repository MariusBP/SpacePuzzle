extends Node2D
class_name LevelTemplate

const LevelList = preload("res://technical/LevelList.gd")

onready var PlanetStart = get_node("Planets/PlanetStart")
onready var GUI = get_node("GUI")

func _ready():
	if !PlanetStart:
		push_error("Could not find starting planet.")
	if !GUI:
		push_error("Could not find GUI.")
