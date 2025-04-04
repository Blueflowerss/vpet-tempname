extends CritterState
func _init() -> void:
	state_id = ACT.FUN;
	state_type = "IDLE";
	super();
func _process(delta: float) -> void:
	if state_time < state_time_limit:
		state_time += delta;
		return
	state_time = 0;
	entity.set_state(ACT.THINK);
func on_state_active():
	print("active")
	entity.emit_signal("play_animation","fun_jump");
func on_state_inactive():
	entity.emit_signal("stop_animation");
	entity.emit_signal("play_animation","back_idle");
	
