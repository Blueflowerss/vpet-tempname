extends CritterState

func _init() -> void:
	state_id = ACT.THINK;
	state_type = "THINK";
	super();
func _ready() -> void:
	super();
func _process(delta: float) -> void:
	if state_time < state_time_limit:
		state_time += delta;
		return
	state_time = 0;
	state_time_limit = act_lengths[state_id] + randf_range(0.1,2);
	#pick a random state that has type `IDLE`
	if entity.states_by_type.has("IDLE"):
		var idle_state_nodes : Array = entity.states_by_type["IDLE"];
		entity.set_state(idle_state_nodes.pick_random().state_id);
