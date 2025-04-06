extends HScrollBar


func _on_value_changed(value: float) -> void:
	Gui.critter_spawn_amount = int(value);
