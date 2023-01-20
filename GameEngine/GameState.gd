extends Node

var object_state = {}
var player
var paused = false
var place_player_at

func get(object_name:String, element_name = null):
	if not object_state.has(object_name):
		object_state[object_name] = {}
	var state = object_state[object_name]
	if element_name:
		if not state.has(element_name): state[element_name] = null
		return state[element_name]
	else: return state

func pause():
	paused = true

func resume():
	paused = false

func enter_scene(scene:String, entry_point:String):
	get_tree().current_scene.remove_child(player)
	get_tree().change_scene(scene)
	place_player_at = entry_point
	
func _process(_delta):
	if place_player_at:
		var scene = get_tree().current_scene
		var entry_node = scene.get_node(place_player_at)
		player.position = entry_node.position
		scene.add_child(player)
		player.enter_current_scene()
		place_player_at = null
