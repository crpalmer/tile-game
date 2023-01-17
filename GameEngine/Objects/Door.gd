extends Thing
class_name Door

export var is_locked = false
export var is_closed = true
var key:Node = null

func _ready():
	ensure_state()

func ensure_state():
	if has_node("Open"): $Open.visible = not is_closed
	if has_node("Locked"): $Locked.visible = is_closed and is_locked
	if has_node("Closed"): $Closed.visible = is_closed and not is_locked
	if has_node("Blocker"): $Blocker.disabled = not is_closed
	
func used_by(who):
	if who is BaseCharacter:
		# if is_locked and who.has_a(key): is_locked = false
		if not is_locked:
			is_closed = not is_closed
			ensure_state()

func set_visibility(o, v):
	if v: o.visible = v
