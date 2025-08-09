extends RichTextLabel
@onready var board: Node2D = %Board
var count := 0

func _ready() -> void:
	board.cell_changed.connect(_on_count_changed)
	track_update()

func _on_count_changed():
	if board.get('simulate'):
		count += 1
	
func track_update():
	while true:
		if board.get('simulate'):
			await get_tree().create_timer(1.0).timeout
			var target = 1 / board.get('delay')
			text = "Target/Actual (Gen/s): " + str(target) + '/' + str(count)
			count = 0
		else:
			text = "Target/Actual (Gen/s): "
			await get_tree().process_frame
