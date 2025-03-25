extends AnimatedSprite2D

enum facing {
	FRONT,
	BACK
}
func _on_critter_facing_back() -> void:
	frame = facing.BACK

func _on_critter_facing_forward() -> void:
	frame = facing.FRONT 


func _on_critter_facing_left() -> void:
	flip_h = true;


func _on_critter_facing_right() -> void:
	flip_h = false;
