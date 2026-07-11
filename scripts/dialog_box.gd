extends MarginContainer

@onready var TextLabel: Label = $LabelMargin/TextLabel
@onready var LetterTimerDisplay: Timer = $LetterTimerDisplay

const MAX_WIDTH = 256

var text = ""
var letterIndex = 0

var letterDisplayTimer := 0.07
var spaceDisplayTimer := 0.05
var punctuactionDisplayTimer := 0.2

signal text_display_finished()

func display_text(textToDisplay: String):
	text = textToDisplay
	TextLabel.text = textToDisplay
	
	await resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		TextLabel.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_maximum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	TextLabel.text = ""
	display_letter()
	
func display_letter():
	TextLabel.text += text[letterIndex]
	letterIndex += 1
	
	if letterIndex >= text.length():
		text_display_finished.emit()
		return
	else:
		match text[letterIndex]:
			"!", "?", ",", '.':
				LetterTimerDisplay.start(punctuactionDisplayTimer)
			' ':
				LetterTimerDisplay.start(spaceDisplayTimer)
			_:
				LetterTimerDisplay.start(letterDisplayTimer)
	
func _on_letter_timer_display_timeout() -> void:
	display_letter()
