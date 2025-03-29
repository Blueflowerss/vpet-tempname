extends CritterState

func _init() -> void:
	state_id = ACT.THINK;
		
func _process(delta: float) -> void:
	if state_time < state_time_limit:
		state_time += delta;
		return
	state_time = 0;
	state_time_limit = randf_range(1,10);
	entity.set_state(ACT.WANDER);
