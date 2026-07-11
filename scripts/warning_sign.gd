extends Node2D

@onready var Sprite = $Texture
@onready var AreaSign = $AreaSign

const lines : Array[String] = [
	"bah",
]

func _unhandled_input(event: InputEvent) -> void:
	if AreaSign.get_overlapping_bodies().size() > 0:
		Sprite.show()
		if event.is_action_pressed("interact") and not DialogManager.isMessageActive:
			Sprite.hide()
			DialogManager.start_message(global_position, lines)
	else:
		Sprite.hide()
		if DialogManager.dialogBox != null:
			DialogManager.dialogBox.queue_free()
			DialogManager.isMessageActive = false
