extends BaseCharacter
class_name Player

func _init():
	randomize()
	GameState.player = self
	hp = 20
	to_hit_ac10 = 10
	damage_dice = {"n": 1, "d": 8, "plus": 1}

func _process(delta):
	process_movement(delta)
	process_attack()
	
func process_movement(delta):
	var dir = Vector2(0, 0)
	if Input.is_action_pressed("left"): dir.x -= 1
	if Input.is_action_pressed("right"): dir.x += 1
	if Input.is_action_pressed("up"): dir.y -= 1
	if Input.is_action_pressed("down"): dir.y += 1
	
	move_and_collide(dir*speed*delta)

func process_attack():
	if attack_available and Input.is_action_pressed("attack"):
		var who = $TrackingArea.who_is_in_area()
		if who: attack(who)
			
func died():
	GameState.player = null
	print_debug("Player died!")
	queue_free()
