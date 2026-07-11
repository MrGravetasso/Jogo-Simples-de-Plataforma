extends Node

@onready var DialogBoxScene = preload("res://prefabs/dialog_box.tscn")
var messageLines : Array[String] = []
var currentLine = 0

var dialogBox
var dialogBoxPosition := Vector2.ZERO

var isMessageActive := false
var canAdvanceMessage := false

func start_message(position: Vector2, lines: Array[String]):
	if isMessageActive:
		return
	
	messageLines = lines
	dialogBoxPosition = position
	show_text()
	isMessageActive = true
	
func show_text():
	dialogBox = DialogBoxScene.instantiate()
	dialogBox.text_display_finished.connect(_on_all_text_displayed)
	
	get_tree().get_root().add_child(dialogBox)
	dialogBox.global_position = dialogBoxPosition
	dialogBox.display_text(messageLines[currentLine])
	canAdvanceMessage = false

func _on_all_text_displayed():
	canAdvanceMessage = true

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("advance_message") and isMessageActive and canAdvanceMessage):
		dialogBox.queue_free()
		currentLine += 1
		if currentLine >= messageLines.size():
			isMessageActive = false
			currentLine = 0
			return
		show_text()
	
	
