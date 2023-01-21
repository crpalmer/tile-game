extends Node2D

func _ready():
	$CanvasModulate.visible = true
	$Doors/Door6to7.key = $MasterKey
	pass
