extends Node2D
class_name Critter
#here i'm typesetting, so we know what 
#values those are supposed to be
@export var grid_position : Vector2i;
@export var impassable_group_list : Array[String]; 
@export var move_speed : float;
# exporting move_speed as a test to try and have it accessible through other files
var current_terrarium : Terrarium;
var ref_sheet : ref_sheet_class;
var last_position : Vector2i;
var path_array : Array[Vector2i];
var move_to_position : Vector2i;
var act_timer : float;
var act_timer_length : float;
#this gonna be a state machine thing
var current_action : BaseState.ACT;
var assigned_states : Dictionary[BaseState.ACT,BaseState];
var states_by_type : Dictionary[String, Array];
signal has_moved;
signal facing_back;
signal facing_forward;
signal facing_left;
signal facing_right;
signal position_changed;
signal stop_animation;
signal play_animation(animation : String);
signal selected;
signal unselected;

func set_state(state: BaseState.ACT) -> void:
	assert(assigned_states.has(state),"entity doesn't have state node: "+BaseState.ACT.keys()[state])
	if assigned_states.has(current_action):
		assigned_states[current_action].process_mode = Node.PROCESS_MODE_DISABLED;
		assigned_states[current_action].on_state_inactive();
	current_action = state;
	assigned_states[state].on_state_active();
	assigned_states[state].process_mode = Node.PROCESS_MODE_ALWAYS;
#setting up initial values
func _ready() -> void:
	current_terrarium = get_parent();
	ref_sheet = ref_sheet_class.new();
	grid_position = Vector2i(0,0);
	move_to_position = grid_position;
	#group states by their type, used for behaviour randomization
	for state : Node in assigned_states.values():
		if !states_by_type.has(state.state_type):
			states_by_type[state.state_type] = [];
		states_by_type[state.state_type].append(state);
	set_state(BaseState.ACT.THINK);
func _physics_process(delta: float) -> void:
	#decided to do animation here
	#position = lerp(position,Vector2((grid_position * 64) + Vector2i(32,32)),delta*3);
	var next_position : Vector2 = Vector2((grid_position * 64) + Vector2i(32,32));
	#var distance_to_next_tile : float = next_position.distance_to(position);
	position = position.move_toward(next_position,1*ref_sheet.MOVE_SPEED);
func _process(delta: float) -> void:
	#a kinda timer so the AI doesn't freak out
	pass
	#standing around, checks if needs anything done, otherwise finds a random spot 
	#to walk to
