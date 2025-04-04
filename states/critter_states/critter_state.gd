extends BaseState
class_name CritterState
func _ready() -> void:
	super();
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	#order your critters like a puppet master
	if event.is_action_pressed("move"):
		var id_path : Array[Vector2i] = entity.current_terrarium.pathfind_conditional(
			entity.current_terrarium.tilemap.local_to_map(entity.global_position),
			entity.current_terrarium.tilemap.local_to_map(entity.get_global_mouse_position()),entity.impassable_group_list).slice(1)
		entity.path_array = id_path;
		entity.set_state(ACT.MOVE);
