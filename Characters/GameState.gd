extends Node

var object_state = {}
var player

func get(object_name:String, element_name = null):
	if not object_state.has(object_name):
		object_state[object_name] = {}
	var state = object_state[object_name]
	if element_name:
		if not state.has(element_name): state[element_name] = null
		return state[element_name]
	else: return state
