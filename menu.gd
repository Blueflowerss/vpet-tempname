extends HBoxContainer


func _on_critter_spawn_pressed() -> void:
	Global.current_terrarium.spawn_critters(Gui.critter_spawn_amount);
