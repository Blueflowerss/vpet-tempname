extends HScrollBar

func _ready() -> void:
	Gui.critter_spawn_amount = value;

func _on_value_changed(value: float) -> void:
	Gui.critter_spawn_amount = int(value);
