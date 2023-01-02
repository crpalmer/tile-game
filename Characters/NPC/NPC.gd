extends BaseCharacter
class_name NPC

var conversation_starter = "Hello"
var speaker_name = "Name"
var attacked_text = "Die!"

func _ready():
	var player = GameState.player
	if player:
		player.connect("entered", self, "on_Player_entered")

func start_conversation():
	$d/Conversation/SpeakerName.text = speaker_name
	$d/Conversation/SpeakerText.text = conversation_starter
	reset_text_box()
	$d/Conversation.visible = true
	
func end_conversation(text = "", delay = 2.0):
	if $d/Conversation.visible:
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
		if (i < parts.size()-1): yield($d/Conversation/More, "pressed")
	reset_text_box()

func player_said(text:String):
	player_said_default(tokenize(text))

func player_said_default(words:Array):
	if "hi" in words:
		say("Hello.")
	elif "hello" in words:
		say("Hi.")
	elif "thanks" in words:
		say("You're welcome.")
	elif "bye" in words:
		end_conversation("Bye.", 1)
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

func _process(delta):
	if hostile:
		end_conversation(attacked_text)
		if attack_available and $TrackingArea.is_player_in_area():
			attack(GameState.player)

func reset_text_box():
	$d/Conversation/PlayerText.text = ""
	$d/Conversation/PlayerText.visible = true
	$d/Conversation/PlayerPrompt.visible = true
	$d/Conversation/More.visible = false
	$d/Conversation/PlayerText.grab_focus()

func on_Player_entered(who):
	if who != self: return
	if hostile: GameState.attack_player(self)
	else: start_conversation()

func on_Player_exited(who):
	if who != self: return
	end_conversation()
	
