extends CanvasLayer
class_name Messages

var messages = []

func _ready():
	$Text.text = ""
	visible = false
	pass

func show_message(msg):
	print_debug(msg)
	visible = true
	messages.push_back(msg)
	while messages.size() > 3: messages.pop_front()
	update_messages()

func update_messages():
	$Text.text = PoolStringArray(messages).join("\n")
	$Timer.start(5)

func _on_Timer_timeout():
	messages.pop_front()
	if messages.size() == 0: visible = false
	else: update_messages()
	
