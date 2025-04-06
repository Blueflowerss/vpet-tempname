extends Label


func _on_critter_amount_value_changed(value: float) -> void:
	text = str(int(value));
