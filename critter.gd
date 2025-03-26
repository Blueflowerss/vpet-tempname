extends Node2D
#here i'm typesetting, so we know what 
#values those are supposed to be
@export var grid_position : Vector2i;
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
	ACT.IDLE: 1.0,
	ACT.MOVE: 0.1,
	ACT.FUN: 0.1 
}
signal has_moved;
signal facing_back;
signal facing_forward;
signal facing_left;
signal facing_right;
#setting up initial values
func _ready() -> void:
	grid_position = Vector2i(0,0);
	move_to_position = grid_position;
	current_action = ACT.IDLE;
func _physics_process(delta: float) -> void:
	#decided to do animation here
	position = lerp(position,Vector2((grid_position * 64) + Vector2i(32,32)),0.01);
	pass
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
			#is bored
			#find a random spot near the critter
			var random_near_spot : Vector2i = Vector2i(randi_range(-5,5),randi_range(-5,5));
			#setting the random spot to move_to_spot
			move_to_position = grid_position + random_near_spot; 
			#getting a path to the spot from A* pathfinding thingi
			path_array = get_parent().astar_grid.get_id_path(grid_position,abs(move_to_position));
			#clear out the first waypoint, which is the critter's position
			path_array.pop_front();
			#time to move
			current_action = ACT.MOVE;
			act_timer_length = act_lengths[ACT.MOVE];
		ACT.MOVE:
			#get the next position at the front
			var next_position = path_array.pop_front();
			#if next pos is null (aka critter reached the destination, then change back to IDLE and don't change position)
			if not next_position:
				current_action = ACT.IDLE;
				act_timer_length = act_lengths[ACT.IDLE];
			else:
				last_position = grid_position;
				grid_position = next_position;
				emit_signal("has_moved");
				var facing = (last_position-grid_position);
				if facing.y > 0:
					emit_signal("facing_back");
				else:
					emit_signal("facing_forward")
				if facing.x == 1:
					emit_signal("facing_left");
				elif facing.x == -1:
					emit_signal("facing_right");
				act_timer_length = act_lengths[ACT.MOVE];
		ACT.FUN:
			pass
