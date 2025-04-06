extends Label


func _on_critter_amount_value_changed(value: int) -> void:
	text = str(value);
