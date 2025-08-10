extends RichTextLabel
@onready var board: Node2D = %Board
var count := 0.0

func _ready() -> void:
	board.cell_changed.connect(_on_count_changed)
	add_theme_font_size_override("normal_font_size", 12)
	track_update()

func _on_count_changed():
	if board.get('simulate'):
		count += 1
	
func track_update():
	while true:
		if board.get('simulate'):
			await get_tree().create_timer(1.0).timeout
			var target = board.get('target_speed')
			text = "Target: " + str(target) + "\n"
			text += "Actual: " + str(count)
			count = 0
		else:
			var target = board.get('target_speed')
			text = "Target: " + str(target) + "\n"
			await get_tree().process_frame
