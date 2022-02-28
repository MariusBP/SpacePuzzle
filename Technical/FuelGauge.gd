extends ProgressBar

func _ready():
	value = Stats.fuel

func _physics_process(_delta):
	value = Stats.fuel
