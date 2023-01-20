extends Node2D

export var scene:String
export var entry_point:String

func _ready():
	GameEngine.enter_scene(scene, entry_point)
