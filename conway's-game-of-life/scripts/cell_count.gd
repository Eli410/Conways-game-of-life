extends RichTextLabel
@onready var board: Node2D = %Board

func _ready() -> void:
	board.cell_changed.connect(_on_count_changed)

func _on_count_changed():
	text = "Alive Cell: " + str(len(board.get("_painted")))
