extends CritterState

const fun_animation_list : Array[String] = [
	"fun_dance",
	"fun_jump"
];
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
	var fun_animation : String = fun_animation_list.pick_random();
	entity.emit_signal("play_animation",fun_animation);
func on_state_inactive():
	entity.emit_signal("stop_animation");
	entity.emit_signal("play_animation","back_idle");
	
