extends HScrollBar


func _on_value_changed(value: int) -> void:
	Gui.critter_spawn_amount = int(value);
