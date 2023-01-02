extends KinematicBody2D
class_name Player

signal collided_with

export var speed = 128
var attack_available = true
var base:BaseCharacter

func _ready():
	base = GameState.get_base_character(name)
	if not base:
		base = BaseCharacter.new()
		GameState.set_base_character(name, base)

func _process(delta):
	process_movement(delta)
	process_attack()
	
func process_movement(delta):
	var dir = Vector2(0, 0)
	if Input.is_action_pressed("left"): dir.x -= 1
	if Input.is_action_pressed("right"): dir.x += 1
	if Input.is_action_pressed("up"): dir.y -= 1
	if Input.is_action_pressed("down"): dir.y += 1
	
	var collision = move_and_collide(dir*speed*delta)
	if collision:
		emit_signal("collided_with", collision)

func process_attack():
	if attack_available and Input.is_action_pressed("attack"):
		var who = $TrackingArea.who_is_in_area()
		if who: 
			GameState.attack(self, who)
			$AttackTimer.start()
			attack_available = false

func _on_AttackTimer_timeout():
	attack_available = true
