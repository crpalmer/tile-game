extends KinematicBody2D
class_name Player

signal collided_with

export var speed = 128

func _process(delta):
	var dir = Vector2(0, 0)
	if Input.is_action_pressed("left"): dir.x -= 1
	if Input.is_action_pressed("right"): dir.x += 1
	if Input.is_action_pressed("up"): dir.y -= 1
	if Input.is_action_pressed("down"): dir.y += 1
	
	var collision = move_and_collide(dir*speed*delta)
	if collision:
		emit_signal("collided_with", collision)
