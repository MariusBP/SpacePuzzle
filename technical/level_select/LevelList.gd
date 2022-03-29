#LevelList.gd
const _order = [
	#Demo
	"Demo1",
	"Demo2"
]

var current_level = 1

func get_level(var index: int):
	current_level = index
	return load(str("res://levels/", _order[index], ".tscn"))
