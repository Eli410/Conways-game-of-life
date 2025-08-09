extends Node2D

@onready var camera_2d: Camera2D = %Camera2D
var cell_size: int = 16
var grid_color: Color = Color.GRAY
var _painted : Dictionary = {}
var mouse_left_hold := false
var mode := "paint"

signal cell_changed()

func _draw() -> void:
	var w: int = get_viewport().size[0]
	var h: int = get_viewport().size[1]

	for x in range(w / cell_size + 1):
		var px = x * cell_size
		draw_line(Vector2(px, 0), Vector2(px, (h - h % cell_size)), grid_color, 1)
	for y in range(h / cell_size + 1):
		var py = y * cell_size
		draw_line(Vector2(0, py), Vector2((w - w % cell_size), py), grid_color, 1)

	for pos : Vector2i in _painted.keys():
		var c : Color = _painted[pos]
		var rect = Rect2i(pos * cell_size, Vector2(cell_size, cell_size))
		draw_rect(rect, c, true)

func paint_cell(cell : Vector2i, color : Color) -> void:
	_painted[cell] = color
	cell_changed.emit()
	queue_redraw()

func erase_cell(cell : Vector2i) -> void:
	_painted.erase(cell)
	cell_changed.emit()
	queue_redraw()

func clear_all() -> void:
	_painted.clear()
	queue_redraw()

func global_to_cell(pos: Vector2i):
	return Vector2i((pos[0] / cell_size), (pos[1] / cell_size))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("mouse_left"):
		mouse_left_hold = true
		mode = "erase" if _painted.get(global_to_cell(get_global_mouse_position())) else "paint"
	elif event is InputEventMouseButton and Input.is_action_just_released("mouse_left"):
		mouse_left_hold = false
		
	if mouse_left_hold:
		var curr_cell = global_to_cell(get_global_mouse_position())
		if mode == 'paint':
			paint_cell(curr_cell, Color.WHITE)
		else:
			erase_cell(curr_cell)

func next_gen():
	pass
