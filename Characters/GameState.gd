extends Node

var object_state = {}

func get(object_name:String, element_name = null):
	if not object_state.has(object_name):
		object_state[object_name] = {}
	var state = object_state[object_name]
	if element_name:
		if not state.has(element_name): state[element_name] = null
		return state[element_name]
	else: return state

func get_base_character(object_name:String):
	return get(object_name, "base-character")

func set_base_character(object_name:String, base:BaseCharacter):
	get(object_name)["base-character"] = base

func attack(from:Node2D, to:Node2D):
	var f = get_base_character(from.name)
	var t = get_base_character(to.name)
	f.attack(t, to)
