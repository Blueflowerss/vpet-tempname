extends Node2D
class_name Critter
#here i'm typesetting, so we know what 
#values those are supposed to be
@export var grid_position : Vector2i;
@export var impassable_group_list : Array[String]; 
var current_terrarium : Terrarium;
var last_position : Vector2i;
var path_array : Array[Vector2i];
var move_to_position : Vector2i;
var act_timer : float;
var act_timer_length : float;
#this gonna be a state machine thing
var current_action : BaseState.ACT;
var assigned_states : Dictionary[BaseState.ACT,Node];
signal has_moved;
signal facing_back;
signal facing_forward;
signal facing_left;
signal facing_right;
signal position_changed;

func set_state(state: BaseState.ACT) -> void:
	assert(assigned_states.has(state),"entity doesn't have state node: "+BaseState.ACT.keys()[state])
	if assigned_states.has(current_action):
		assigned_states[current_action].process_mode = Node.PROCESS_MODE_DISABLED;
	current_action = state;
	assigned_states[state].process_mode = Node.PROCESS_MODE_ALWAYS;
#setting up initial values
func _ready() -> void:
	current_terrarium = get_parent();
	grid_position = Vector2i(0,0);
	move_to_position = grid_position;
	set_state(BaseState.ACT.THINK);
func _physics_process(delta: float) -> void:
	#decided to do animation here
	#position = lerp(position,Vector2((grid_position * 64) + Vector2i(32,32)),delta*3);
	var next_position : Vector2 = Vector2((grid_position * 64) + Vector2i(32,32));
	var distance_to_next_tile : float = next_position.distance_to(position);
	position = position.move_toward(next_position,8);
func _process(delta: float) -> void:
	#a kinda timer so the AI doesn't freak out
	if act_timer < act_timer_length:
		act_timer += delta;
		return
	act_timer = 0;
	#standing around, checks if needs anything done, otherwise finds a random spot 
	#to walk to
