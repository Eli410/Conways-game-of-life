extends RichTextLabel

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		text = "Global mouse pos: " + str(get_global_mouse_position())
