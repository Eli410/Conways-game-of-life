extends HBoxContainer

@onready var play: Button = $Play
@onready var pause: Button = $Pause

func _on_play_pressed() -> void:
	play.visible = false
	pause.visible = true
	

func _on_pause_pressed() -> void:
	play.visible = true
	pause.visible = false
