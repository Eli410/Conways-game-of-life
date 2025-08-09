extends Node2D

@onready var camera_2d: Camera2D = %Camera2D
var cell_size: int = 16
var grid_color: Color = Color.GRAY
var _painted : Dictionary = {}
var mouse_left_hold := false
var mode := "paint"
var simulate := false
var delay := 0.2

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
	
	cell_changed.emit()

func paint_cell(cell : Vector2i, color : Color) -> void:
	_painted[cell] = color
	queue_redraw()

func erase_cell(cell : Vector2i) -> void:
	_painted.erase(cell)
	queue_redraw()

func clear_all() -> void:
	_painted.clear()
	queue_redraw()

func global_to_cell(pos: Vector2i):
	return pos / cell_size
	#return Vector2i((pos[0] / cell_size), (pos[1] / cell_size))

func get_neighbors(pos: Vector2i):
	const neighboring_squares := [
		Vector2i(-1,-1), Vector2i(0,-1), Vector2i(1,-1),
		Vector2i(-1, 0),                 Vector2i(1, 0),
		Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1)
	]
	var neighbors := {}
	for n in neighboring_squares:
		if _painted.get(pos + n):
			neighbors[pos + n] = 1
		else:
			neighbors[pos + n] = 0
	return neighbors

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
	var next_gen := {}
	var alive_candidate := {}
	for cell in _painted.keys():
		var neighbors = get_neighbors(cell)
		for n in neighbors:
			if alive_candidate.get(n):
				alive_candidate[n] += 1
			else:
				alive_candidate[n] = 1
		
		var num_neighbors = neighbors.values().count(1)
		if num_neighbors < 2:
			pass
		elif num_neighbors == 2 or num_neighbors == 3:
			next_gen[cell] = Color.WHITE
		elif num_neighbors > 3:
			pass
	
	for c in alive_candidate.keys():
		if alive_candidate[c] == 3:
			next_gen[c] = Color.WHITE
	
	_painted = next_gen

func _on_next_pressed() -> void:
	if not simulate:
		next_gen()
		queue_redraw()

func _on_play_pressed() -> void:
	simulate = true

func _on_pause_pressed() -> void:
	simulate = false

func run_simulation():
	while true:
		if simulate:
			await get_tree().create_timer(delay).timeout
			next_gen()
			queue_redraw()
		else:
			await get_tree().process_frame
			
func _ready() -> void:
	run_simulation()
