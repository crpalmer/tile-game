extends Node

var object_state = {}
var player
var paused = false

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
	if not player: player = load("res://GameEngine/Actors/Player.tscn").instance()
	else:
		var fade = player.get_node("Camera2D/HUD/Fade")
		var anim:AnimationPlayer = fade.get_node("AnimationPlayer")
		anim.play("Fade")
		print("anim1 start")
		yield(anim, "animation_finished")
		print("anim1 finish")
	
	get_tree().current_scene.remove_child(player)
	get_tree().change_scene(scene)
	
	yield(get_tree(), "idle_frame")
	
	var anim:AnimationPlayer = player.get_node("Camera2D/HUD/Fade/AnimationPlayer")
	var scene_node = get_tree().current_scene
	var entry_node = scene_node.get_node(entry_point)
	player.position = entry_node.position
	scene_node.add_child(player)
	player.enter_current_scene()
	anim.play_backwards("Fade")
