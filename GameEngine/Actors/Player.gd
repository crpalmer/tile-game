extends Actor
class_name Player

var inventory = []
var messages

func _init():
	randomize()
	GameState.player = self
	hp = 20
	to_hit_ac10 = 10
	damage_dice = {"n": 1, "d": 8, "plus": 1}
	messages = $Camera2D/HUD/Messages

func _process(delta):
	if GameState.paused: return
	
	process_movement(delta)
	process_attack()
	process_use()
	
func process_movement(delta):
	var dir = Vector2(0, 0)
	if Input.is_action_pressed("left"): dir.x -= 1
	if Input.is_action_pressed("right"): dir.x += 1
	if Input.is_action_pressed("up"): dir.y -= 1
	if Input.is_action_pressed("down"): dir.y += 1
	
	var collision:KinematicCollision2D = move_and_collide(dir*speed*delta)
	if collision and collision.collider is InventoryThing:
		inventory.push_back(collision.collider)
		collision.collider.get_parent().remove_child(collision.collider)

func process_attack():
	if attack_available and Input.is_action_pressed("attack"):
		var in_area:Array = $CloseArea.who_is_in_area()
		if in_area.size() > 0: attack(in_area[randi() % in_area.size()])

func process_use():
	if Input.is_action_just_released("use") and not Input.is_action_just_released("used"):
		for use_on in $CloseArea.who_is_in_area():
			#if use_on is InventoryThing: Inventory.add(use_on)
			if use_on is Thing: use_on.used_by(self)
		
func died():
	GameState.player = null
	print_debug("Player died!")
	queue_free()

func show_message(message):
	messages.show_message(message)
