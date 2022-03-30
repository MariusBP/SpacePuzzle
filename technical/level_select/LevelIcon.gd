extends PanelContainer

signal level_selected

onready var Number = $Number
onready var Lock = $MarginContainer

var locked = true setget set_locked
var level_num = 1 setget set_level

func set_locked(value):
	locked = value
	Lock.visible = value
	Number.visible = !value

func set_level(value):
	level_num = value
	Number.text = str(level_num)

func _on_LevelIcon_gui_input(event):
	if locked:
		return
	if event is InputEventMouseButton and event.pressed:
		print("Clicked Level:", level_num)
		emit_signal("level_selected", level_num)
