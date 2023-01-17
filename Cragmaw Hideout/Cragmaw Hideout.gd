extends Node2D

func _ready():
	$CanvasModulate.visible = true
	set_scale(Vector2(0.25, 0.25))
	$Player.set_scale(Vector2(4,4))
	pass
