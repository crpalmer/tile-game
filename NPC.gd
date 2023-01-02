extends BaseCharacter
class_name NPC

var conversation_starter = "Hello"
var speaker_name = "Name"

func _ready():
	start_conversation()
	say_in_parts(["hi", "there", "testing"])
	
func set_speaker_name(name:String):
	speaker_name = name
	
func set_conversation_starter(starter:String):
	conversation_starter = starter

func start_conversation():
	$d/Conversation/SpeakerName.text = speaker_name
	$d/Conversation/SpeakerText.text = conversation_starter
	reset_text_box()
	$d/Conversation.visible = true
	
func end_conversation(text = "", delay = 2.0):
	$d/Conversation/PlayerText.visible = false
	$d/Conversation/PlayerPrompt.visible = false
	if text.length() > 0:
		$d/Conversation/SpeakerText.text = text
		yield(get_tree().create_timer(delay), "timeout")
	$d/Conversation.visible = false

func say(text:String):
	$d/Conversation/SpeakerText.text = text
	reset_text_box()

func say_in_parts(parts:Array):
	$d/Conversation/PlayerText.visible = false
	$d/Conversation/More.visible = true
	for i in parts.size():
		$d/Conversation/SpeakerText.text = parts[i]
		if (i < parts.size()): yield($d/Conversation/More, "pressed")
	reset_text_box()

func player_said(text:String):
	player_said_default(tokenize(text))

func player_said_default(words:Array):
	if "hi" in words:
		say("Hello.")
	elif "hello" in words:
		say("Hi.")
	else:
		say("I don't understand")

var delimiters = [' ', '	', '\n', ',', '.', '?', '!', '&']

func tokenize(text:String):
	var words = []
	var start = 0
	var i = 0
	text = text.to_lower()
	while i <= text.length():
		if i == text.length() or text[i] in delimiters:
			if i > start:
				words.push_back(text.substr(start, i-start))
			start = i+1
		i += 1
	return words

func reset_text_box():
	$d/Conversation/PlayerText.text = ""
	$d/Conversation/PlayerText.visible = true
	$d/Conversation/PlayerPrompt.visible = true
	$d/Conversation/More.visible = false
	$d/Conversation/PlayerText.grab_focus()

func _on_PlayerText_text_entered(new_text):
	if new_text != "":
		player_said(new_text)

func _on_NPC_body_entered(body):
	if body is Player:
		start_conversation()

func _on_NPC_body_exited(body):
	if body is Player:
		end_conversation()
