extends Node2D
var astar_grid : AStarGrid2D = AStarGrid2D.new();
var grid_size : Vector2i = Vector2i(32,32);
var tilemap : TileMapLayer;
func _ready() -> void:
	tilemap = $TileMapLayer;
	astar_grid.region = Rect2i(Vector2i.ZERO,grid_size);
	astar_grid.update();
	$GridDisplayScene.grid_size = grid_size;
