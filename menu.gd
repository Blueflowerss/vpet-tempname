extends HBoxContainer


func _on_critter_spawn_pressed() -> void:
	Global.player_control.current_mouse_mode = Global.player_control.mouse_mode.PLACE;
