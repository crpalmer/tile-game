extends Thing
class_name Door

export var is_locked = false
export var is_closed = true
var key:Node = null

func _ready():
	ensure_state()

func ensure_state():
	if has_node("Open"): $Open.visible = not is_closed
	if has_node("Locked"): $Locked.visible = is_locked
	if has_node("Closed"): $Closed.visible = is_closed
	if has_node("Blocker"): $Blocker.disabled = not is_closed
	
func used_by(who):
	if who is Actor:
		# if is_locked:
		# if who.has_a(key): is_locked = false
		# else show message the door appears to be locked
		if not is_locked:
			is_closed = not is_closed
			ensure_state()
