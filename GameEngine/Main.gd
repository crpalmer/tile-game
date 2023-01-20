extends Node2D

export var scene:String
export var entry_point:String

func _ready():
	GameState.player = $Player
	GameState.enter_scene(scene, entry_point)
	var level = load(filename)
