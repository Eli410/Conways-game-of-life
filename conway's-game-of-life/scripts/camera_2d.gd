extends Camera2D
@onready var board: Node2D = %Board

var _dragging: bool = false
var delta_accumulated : Vector2 = Vector2.ZERO

signal camera_moved()

func _input(event: InputEvent) -> void:
	# When the drag button is pressed or released
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		_dragging = event.pressed

	# While the mouse moves and we're dragging, pan the camera
	elif _dragging and event is InputEventMouseMotion:
		var delta = event.relative
		#if abs(delta[0]) >= 16 and abs(delta[1]) >= 16:
		delta_accumulated += delta
		if abs(delta_accumulated[0]) >= board.get('cell_size') or abs(delta_accumulated[1]) >= board.get('cell_size'):
			position -= delta_accumulated.snapped(Vector2(board.get('cell_size'), board.get('cell_size')))
			camera_moved.emit()
			delta_accumulated = Vector2.ZERO
		
func set_top_left(pos: Vector2):
	position = pos + Vector2(get_viewport().size) / 2

func set_center(pos: Vector2 = get_global_mouse_position()):
	position = pos
	
func get_top_left():
	return global_position - Vector2(get_viewport().size) / 2
	
func _ready() -> void:
	set_top_left(Vector2(0, 0))
	board.zoom_changed.connect(set_center)
