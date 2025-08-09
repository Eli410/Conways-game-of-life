extends PanelContainer

func _ready() -> void:
	visible = false
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and Input.is_key_pressed(KEY_F3):
		visible = not visible
