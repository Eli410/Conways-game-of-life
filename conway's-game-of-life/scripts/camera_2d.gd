extends Camera2D

@export var drag_button: int = MOUSE_BUTTON_RIGHT
var _dragging: bool = false

func _input(event: InputEvent) -> void:
	# When the drag button is pressed or released
	if event is InputEventMouseButton and event.button_index == drag_button:
		_dragging = event.pressed

	# While the mouse moves and we're dragging, pan the camera
	elif event is InputEventMouseMotion and _dragging:
		var delta = event.relative
		# Move camera opposite to mouse movement
		position -= delta

func set_top_left(pos: Vector2):
	position = pos + Vector2(get_viewport().size) / 2

func _ready() -> void:
	set_top_left(Vector2(-1, -1))
