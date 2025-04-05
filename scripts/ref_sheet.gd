class_name ref_sheet_class
#attributes (aren't pre-calculated)
var STRENGTH : float = 10;
var DEXTERITY : float = 10;
#stats (pre-calculated)
var MOVE_SPEED : float;

func _init() -> void:
	compute_stats();
	print(MOVE_SPEED)

func compute_stats() -> void:
	MOVE_SPEED = (STRENGTH/4)+(DEXTERITY/2)
