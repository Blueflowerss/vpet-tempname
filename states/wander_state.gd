extends CritterState

func _init() -> void:
	state_id = ACT.WANDER;

func _process(delta: float) -> void:
		# randomize duration of idle time whenever idle state becomes current state
		#is bored
		#find a random spot near the critter
		var random_near_spot : Vector2i = Vector2i(randi_range(-5,5),randi_range(-5,5));
		#setting the random spot to move_to_spot
		entity.move_to_position = entity.grid_position + random_near_spot; 
		#getting a path to the spot from A* pathfinding thingi
		@warning_ignore("unsafe_method_access")
		entity.path_array = entity.current_terrarium.pathfind_conditional(entity.grid_position,abs(entity.move_to_position),entity.impassable_group_list).slice(1);
		#time to move
		emit_signal("state_change","MOVE");
		entity.set_state(ACT.MOVE);
