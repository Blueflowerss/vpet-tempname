extends CritterState

func _init() -> void:
	state_id = ACT.MOVE;
	state_type = "MOVEMENT";
	super();
func _ready() -> void:
	super();
func _process(delta: float) -> void:
	if state_time < state_time_limit:
		state_time += delta;
		return
	state_time = 0;
	#get the next position at the front
	#if next pos is null (aka critter reached the destination, then change back to IDLE and don't change position)
	if entity.path_array.is_empty() or not entity.path_array.front() or entity.current_terrarium.are_entities_blocking_tile(entity.path_array.front(),entity.impassable_group_list):
		entity.set_state(ACT.THINK);
		entity.emit_signal("position_changed");
	else:
		var next_position : Vector2i = entity.path_array.pop_front();
		entity.last_position = entity.grid_position;
		entity.grid_position = next_position;
		entity.emit_signal("has_moved");
		var facing : Vector2 = (entity.last_position-entity.grid_position);
		if facing.y > 0:
			entity.emit_signal("facing_back");
		else:
			entity.emit_signal("facing_forward")
		if facing.x == 1:
			entity.emit_signal("facing_left");
		elif facing.x == -1:
			entity.emit_signal("facing_right");
