extends MarginContainer

var num_levels = 1
var current_grid = 1
var grid_width = 710

@onready var LevelGrid = find_child("LevelGrid")

func _ready():
	# Number all the level boxes and unlock them
	# Replace with your game's level/unlocks/etc.
	# You can also connect the "level_selected" signals
	num_levels = LevelGrid.get_child_count()
	for box in LevelGrid.get_children():
		var num = box.get_position_in_parent() + 1 + 18 * LevelGrid.get_position_in_parent()
		box.level_num = num
		box.locked = false
