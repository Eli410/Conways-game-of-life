extends RichTextLabel

func _ready() -> void:
	add_theme_font_size_override("normal_font_size", 12)

func _on_play_pressed() -> void:
	text = "Simulating"

func _on_pause_pressed() -> void:
	text = "Paused"
