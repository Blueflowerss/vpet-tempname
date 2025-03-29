extends Node
class_name BaseState
enum ACT {
	IDLE,
	MOVE,
	FUN,
	THINK,
	WANDER,
	NONE
}
const act_lengths : Dictionary[ACT,float] = {
	ACT.MOVE:0.1,
	ACT.FUN:2,
	ACT.THINK:1,
	ACT.WANDER:0.1
}
var state_time : float = 0;
var state_time_limit : float = 1;
var state_id : ACT = ACT.NONE;
signal state_change(STATE : String);
var entity : Critter;
func _ready() -> void:
	entity = get_parent();
	entity.assigned_states[state_id] = self;
	
func _process(delta: float) -> void:
	print(entity);
