extends RichTextLabel


func _on_play_pressed() -> void:
	text = "Simulating"

func _on_pause_pressed() -> void:
	text = "Paused"
