extends Node2D
class_name Terrarium
var critter : PackedScene = preload("res://critter.tscn");
var astar_grid : AStarGrid2D = AStarGrid2D.new();
var terrain_obstacle_grid : Array[Vector2i];
var obstacle_grid : Dictionary[Vector2i,bool] = {};
var grid_size : Vector2i = Vector2i(32,32);
var tilemap : TileMapLayer;
func _ready() -> void:
	tilemap = $TileMapLayer;
	astar_grid.region = Rect2i(Vector2i.ZERO,grid_size);
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES;
	astar_grid.update();
	$GridDisplayScene.grid_size = grid_size;
	spawn_critters(10);
	refresh_terrain_grid();
	refresh_entity_map();
func pathfind_conditional(from : Vector2i, to : Vector2i, impassable : Array[String]) -> Array[Vector2i]:
	astar_grid.fill_solid_region(astar_grid.region,false);
	for terrain_point : Vector2i in terrain_obstacle_grid:
		astar_grid.set_point_solid(terrain_point);
	for entity in get_tree().get_nodes_in_group("entity"):
		for tag : String in impassable:
			if entity.is_in_group(tag):
				astar_grid.set_point_solid(entity.grid_position);
				break;
	return astar_grid.get_id_path(from,to,true);
func spawn_critters(amount : int) -> void:
	for i in range(1,amount):
		var critterNode : Critter = critter.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED);
		critterNode.connect("has_moved",refresh_entity_map);
		add_child(critterNode);
func refresh_terrain_grid() -> void:
	for x in range(astar_grid.region.position.x,astar_grid.region.end.x):
		for y in range(astar_grid.region.position.y,astar_grid.region.end.y):
			var point : Vector2i = Vector2i(x,y);
			var tile : TileData = tilemap.get_cell_tile_data(point);
			if tile and tile.has_custom_data("blocking_path"):
				terrain_obstacle_grid.append(point);
func refresh_entity_map() -> void:
	entity_layer.clear();
	for entity in get_tree().get_nodes_in_group("entities"):
		entity_layer.set_cell(critter.grid_position,1,Vector2i(0,0));
	#var merged_grids = obstacle_grid.merged(terrain_obstacle_grid);
	#for point : Vector2i in merged_grids.keys():
	#	astar_grid.set_point_solid(point);
