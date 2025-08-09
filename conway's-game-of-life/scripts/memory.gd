extends RichTextLabel

func _process(_d):
	var mb = 1024.0 * 1024.0
	text = "Mem: %.1f MB (peak %.1f)" % [Performance.get_monitor(Performance.MEMORY_STATIC)/mb, Performance.get_monitor(Performance.MEMORY_STATIC_MAX)/mb]
