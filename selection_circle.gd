extends Sprite2D


func _on_critter_selected() -> void:
	visible = true;


func _on_critter_unselected() -> void:
	visible = false;
