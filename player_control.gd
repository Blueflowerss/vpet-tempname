extends Node2D
class_name PlayerControl
var selection_square : Array[Vector2] = [Vector2.ZERO,Vector2.ZERO];
var selected_units : Array[Node2D];
var current_mouse_mode : mouse_mode = mouse_mode.DEFAULT;
var place_object : Critter;
enum mouse_mode {
	DEFAULT,
	PLACE
}
var current_terrarium : Terrarium;
func _ready() -> void:
	Global.player_control = self;
	current_terrarium = Global.current_terrarium;
func _physics_process(delta: float) -> void:
	pass
func _unhandled_input(event: InputEvent) -> void:
		if event is InputEventMouseButton:
			#mouse mode
			match current_mouse_mode:
				mouse_mode.DEFAULT:
					#mouse button
					match event.button_index:
						MOUSE_BUTTON_LEFT:
							if event.pressed:
								selection_square[0] = get_global_mouse_position();
								selection_square[1] = get_global_mouse_position();
								$selection_rect.position = selection_square[0];
								if !selected_units.is_empty():
									for entity : Critter in selected_units:
										entity.emit_signal("unselected");
								selected_units = [];
							else: 
								$selection_rect.visible = false;
								selected_units = current_terrarium.get_units_in_rect(floor(selection_square[0]/current_terrarium.grid_cell_size),floor(selection_square[1]/current_terrarium.grid_cell_size))
								#if clicked on square, select only one entity
								if selection_square[0].distance_to(selection_square[1]) < current_terrarium.grid_cell_size.x and selected_units.front() != null:
									selected_units = [selected_units.front()];
								if !selected_units.is_empty():
									for entity : Critter in selected_units:
										entity.emit_signal("selected");
								#reset the square
								selection_square = [Vector2.ZERO,Vector2.ZERO];
						MOUSE_BUTTON_RIGHT:
								#order your critters like a puppet master
									for entity : Critter in selected_units:
										var id_path : Array[Vector2i] = entity.current_terrarium.pathfind_conditional(
											entity.current_terrarium.tilemap.local_to_map(entity.global_position),
											entity.current_terrarium.tilemap.local_to_map(entity.get_global_mouse_position()),entity.impassable_group_list).slice(1)
										entity.path_array = id_path;
										entity.set_state(BaseState.ACT.MOVE);
				mouse_mode.PLACE:
					var tile_map_layer : TileMapLayer = Global.current_terrarium.tilemap;
					var mouse_pos : Vector2i = tile_map_layer.local_to_map(get_global_mouse_position())
					Global.current_terrarium.spawn_critters(Gui.critter_spawn_amount,mouse_pos)
					current_mouse_mode = mouse_mode.DEFAULT;
					
		if event is InputEventMouseMotion:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				$selection_rect.visible = true;
				selection_square[1] = get_global_mouse_position();
				var selection_rect_size : Vector2 = selection_square[1]-selection_square[0];
				var selection_rect_size_abs : Vector2 = abs(selection_rect_size);
				#couldn't get the Panel Node to have negative size, so i had to do this hack
				$selection_rect.scale = Vector2.ONE;
				if selection_rect_size.x < 0:
					$selection_rect.scale.x = -1;
				if selection_rect_size.y < 0:
					$selection_rect.scale.y = -1;
				$selection_rect.set_size(selection_rect_size_abs);
