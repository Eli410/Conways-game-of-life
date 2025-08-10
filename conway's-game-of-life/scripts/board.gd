extends Node2D
@onready var camera_2d: Camera2D = %Camera2D

var cell_size: int = 16
var grid_color: Color = Color.GRAY
var _painted : Dictionary = {}
var mouse_left_hold := false
var mode := "paint"
var simulate := false
var num_sim_to_run := 0.0
var target_speed := 5.0

signal cell_changed()
signal zoom_changed()

func _draw() -> void:
	draw_grid()

	for pos : Vector2i in _painted.keys():
		var c : Color = _painted[pos]
		var rect = Rect2i(pos * cell_size, Vector2(cell_size, cell_size))
		draw_rect(rect, c, true)

func draw_grid():
	var size_snapped = get_viewport().size.snapped(Vector2(cell_size, cell_size))
	var w: int = int(size_snapped.x) + cell_size
	var h: int = int(size_snapped.y) + cell_size

	var top_left: Vector2i = Vector2i(camera_2d.call("get_top_left"))

	# Align to the grid once, then draw using aligned bases
	var base_x: int = top_left.x - (top_left.x % cell_size)
	var base_y: int = top_left.y - (top_left.y % cell_size)
	var x_lines: int = w / cell_size + 1
	var y_lines: int = h / cell_size + 1

	for x in range(x_lines):
		var px: int = base_x + x * cell_size
		draw_line(
			Vector2(px, base_y),
			Vector2(px, base_y + h),
			grid_color, 1
		)

	for y in range(y_lines):
		var py: int = base_y + y * cell_size
		draw_line(
			Vector2(base_x, py),
			Vector2(base_x + w, py),
			grid_color, 1
		)

func paint_cell(cell : Vector2i, color : Color) -> void:
	_painted[cell] = color

func erase_cell(cell : Vector2i) -> void:
	_painted.erase(cell)

func global_to_cell(pos: Vector2i):
	return pos / cell_size

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
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		cell_size = min(64, cell_size + 1)
		queue_redraw()
		zoom_changed.emit()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		cell_size = max(2, cell_size - 1)
		queue_redraw()
		zoom_changed.emit()
		
		
	if mouse_left_hold:
		var curr_cell = global_to_cell(get_global_mouse_position())
		if mode == 'paint':
			paint_cell(curr_cell, Color.WHITE)
		else:
			erase_cell(curr_cell)

func run_sim(num_gen: float = 1):
	
	for i in range(max(num_gen, 1)):
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
		
		cell_changed.emit()
		_painted = next_gen

func _on_next_pressed() -> void:
	if not simulate:
		run_sim()

func _on_play_pressed() -> void:
	simulate = true

func _on_pause_pressed() -> void:
	simulate = false

func _physics_process(delta: float) -> void:
	if not simulate:
		return
	num_sim_to_run += target_speed / Engine.physics_ticks_per_second
	run_sim(floor(num_sim_to_run))
	num_sim_to_run -= floor(num_sim_to_run)

func _process(delta: float) -> void:
	queue_redraw()

func _on_spin_box_value_changed(value: float) -> void:
	target_speed = value
