extends RichTextLabel
@onready var board: Node2D = %Board
var count := 0


func _ready() -> void:
	board.cell_changed.connect(_on_count_changed)

func _on_count_changed():
	count += 1
	text = "Generation " + str(count)
