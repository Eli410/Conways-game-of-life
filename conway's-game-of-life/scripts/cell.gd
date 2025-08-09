extends RichTextLabel

@onready var board: Node2D = %Board
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		text = "Cell: " + str(board.call("global_to_cell", get_global_mouse_position())) + "\n"
		var n = board.call("get_neighbors", board.call("global_to_cell", get_global_mouse_position()))
		text += "Neighbors: " + str(n.values().count(1))
