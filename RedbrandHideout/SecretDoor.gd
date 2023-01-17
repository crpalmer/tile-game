extends Door

func _ready():
	$Closed/LightOccluder2D.set_scale(Vector2(1, 3))
