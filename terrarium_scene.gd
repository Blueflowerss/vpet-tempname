extends Node2D
class_name Terrarium
var astar_grid : AStarGrid2D = AStarGrid2D.new();
var grid_size : Vector2i = Vector2i(32,32);
var tilemap : TileMapLayer;
func _ready() -> void:
	tilemap = $TileMapLayer;
	astar_grid.region = Rect2i(Vector2i.ZERO,grid_size);
	astar_grid.update();
	$GridDisplayScene.grid_size = grid_size;
	refresh_terrain_grid();
func refresh_terrain_grid() -> void:
	for x in range(astar_grid.region.position.x,astar_grid.region.end.x):
		for y in range(astar_grid.region.position.y,astar_grid.region.end.y):
			var point : Vector2i = Vector2i(x,y);
			var tile : TileData = tilemap.get_cell_tile_data(point);
			if tile and tile.has_custom_data("blocking_path"):
				astar_grid.set_point_solid(point);
	pass
