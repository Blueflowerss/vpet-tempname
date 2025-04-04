extends CritterState
func _init() -> void:
	state_id = ACT.FUN;
	state_type = "IDLE";
	super();
func _process(delta: float) -> void:
	entity.emit_signal("play_animation","fun_jump");
	if state_time < state_time_limit:
		state_time += delta;
		return
	state_time = 0;
	entity.emit_signal("play_animation","RESET");
	entity.emit_signal("play_animation","back_idle");
	entity.set_state(ACT.THINK);
