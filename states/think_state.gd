extends CritterState

func _init() -> void:
	state_id = ACT.THINK;
func _ready() -> void:
	super();
func _process(delta: float) -> void:
	if state_time < state_time_limit:
		state_time += delta;
		return
	state_time = 0;
	state_time_limit = act_lengths[state_id] + randf_range(0.1,2);
	if entity.assigned_states.has(ACT.WANDER):
		entity.set_state(ACT.WANDER);
