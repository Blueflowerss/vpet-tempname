extends Node2D
#here i'm typesetting, so we know what 
#values those are supposed to be
@export var grid_position : Vector2i;
var current_terrarium : Terrarium;
var last_position : Vector2i;
var path_array : Array[Vector2i];
var move_to_position : Vector2i;
var act_timer : float;
var act_timer_length : float;
#this gonna be a state machine thing
var current_action : ACT;
enum ACT {
	IDLE,
	MOVE,
	FUN
}
var act_lengths : Dictionary[ACT,float] = {
	ACT.IDLE: 0,
	ACT.MOVE: 0.1,
	ACT.FUN: 0.1 
}
signal has_moved;
signal facing_back;
signal facing_forward;
signal facing_left;
signal facing_right;

func set_state(state: ACT) -> void:
	current_action = state;
	act_timer_length = act_lengths[state];
#setting up initial values
func _ready() -> void:
	current_terrarium = get_parent();
	grid_position = Vector2i(0,0);
	move_to_position = grid_position;
	current_action = ACT.IDLE;
func _physics_process(delta: float) -> void:
	#decided to do animation here
	#position = lerp(position,Vector2((grid_position * 64) + Vector2i(32,32)),delta*3);
	var next_position : Vector2 = Vector2((grid_position * 64) + Vector2i(32,32));
	var distance_to_next_tile : float = next_position.distance_to(position);
	position += position.direction_to(next_position) * 10;
func _process(delta: float) -> void:
	#a kinda timer so the AI doesn't freak out
	if act_timer < act_timer_length:
		act_timer += delta;
		return
	act_timer = 0;
	#standing around, checks if needs anything done, otherwise finds a random spot 
	#to walk to
	match current_action:
		ACT.IDLE:
			# randomize duration of idle time whenever idle state becomes current state
			act_lengths[ACT.IDLE] = randf_range(0.5, 6.0) 
			print(act_lengths)
			#is bored
			#find a random spot near the critter
			var random_near_spot : Vector2i = Vector2i(randi_range(-5,5),randi_range(-5,5));
			#setting the random spot to move_to_spot
			move_to_position = grid_position + random_near_spot; 
			#getting a path to the spot from A* pathfinding thingi
			@warning_ignore("unsafe_method_access")
			path_array = current_terrarium.astar_grid.get_id_path(grid_position,abs(move_to_position)).slice(1);
			#time to move
			set_state(ACT.MOVE);
		ACT.MOVE:
			#get the next position at the front
			#if next pos is null (aka critter reached the destination, then change back to IDLE and don't change position)
			if not path_array.front():
				set_state(ACT.IDLE);
			else:
				var next_position : Vector2i = path_array.pop_front();
				last_position = grid_position;
				grid_position = next_position;
				emit_signal("has_moved");
				var facing : Vector2 = (last_position-grid_position);
				if facing.y > 0:
					emit_signal("facing_back");
				else:
					emit_signal("facing_forward")
				if facing.x == 1:
					emit_signal("facing_left");
				elif facing.x == -1:
					emit_signal("facing_right");
				set_state(ACT.MOVE);
		ACT.FUN:
			pass
func _input(event: InputEvent) -> void:
	#order your critters like a puppet master
	if event.is_action_pressed("move"):
		var id_path : Array[Vector2i] = current_terrarium.astar_grid.get_id_path(
			current_terrarium.tilemap.local_to_map(global_position),
			current_terrarium.tilemap.local_to_map(get_global_mouse_position())
			).slice(1)
		path_array = id_path;
		set_state(ACT.MOVE);
	
