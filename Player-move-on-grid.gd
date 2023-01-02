extends KinematicBody2D

signal collided_with

export var speed = 96
var move_needed = Vector2(0, 0)

func move_to_cells(move:Vector2):
	move.x = floor(move.x/16)*16
	move.y = floor(move.y/16)*16
	return move

func _process(delta):
	var dir = Vector2(0, 0)
	if Input.is_action_pressed("left"): dir.x -= 1
	if Input.is_action_pressed("right"): dir.x += 1
	if Input.is_action_pressed("up"): dir.y -= 1
	if Input.is_action_pressed("down"): dir.y += 1
	
	move_needed += dir*speed*delta
	var move_possible = move_to_cells(move_needed)
	if move_possible.x != 0 or move_possible.y != 0:
		move_needed -= move_possible
		print_debug("position", position, " move_possible: ", dir, " remaining", move_needed)
		var p = position
		var collision = move_and_collide(move_possible)
		if collision:
			position = p
			emit_signal("collided_with", collision)
