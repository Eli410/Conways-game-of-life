@tool
extends Node2D

@export var cell_size: int = 16
@export var grid_size: Vector2i = Vector2i(40, 25) 
@export var grid_color: Color = Color.GRAY
@export var line_width: float = 1.0

var _painted : Dictionary = {}

func _draw() -> void:
	var w: int = grid_size.x * cell_size
	var h: int = grid_size.y * cell_size

	for x in range(grid_size.x + 1):
		var px = x * cell_size
		draw_line(Vector2(px, 0), Vector2(px, h), grid_color, line_width)
	for y in range(grid_size.y + 1):
		var py = y * cell_size
		draw_line(Vector2(0, py), Vector2(w, py), grid_color, line_width)

	for pos : Vector2i in _painted.keys():
		var c : Color = _painted[pos]
		var rect = Rect2i(pos * cell_size, Vector2(cell_size, cell_size))
		draw_rect(rect, c, true)

func paint_cell(cell : Vector2i, color : Color) -> void:
	_painted[cell] = color
	queue_redraw()

func erase_cell(cell : Vector2i) -> void:
	_painted.erase(cell)
	queue_redraw()

func clear_all() -> void:
	_painted.clear()
	queue_redraw()
