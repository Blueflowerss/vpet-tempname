extends Node2D

@onready var tile_map = $"../TileMapLayer"

var astar_grid: AStarGrid2D
var current_id_path: Array[Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(64,64)
	astar_grid.update()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move") == false:
		return
	
	var id_path = astar_grid.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(get_global_mouse_position())
		).slice(1)
	
	if id_path.is_empty() == false:
		current_id_path = id_path


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if current_id_path.is_empty():
		return
	
	var target_position = tile_map.map_to_local(current_id_path.front())
	
	global_position = global_position.move_toward(target_position, 3)
	
	if global_position == target_position:
		current_id_path.pop_front()
