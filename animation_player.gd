extends AnimationPlayer

# Made an animation called "fun_jump" so I think you can have a signal reciever here that runs
# play("fun_jump") when its detected, would also need to play back_idle when its moving or thinking
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("back_idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_critter_play_animation(animation: String) -> void:
	assert(has_animation(animation), "no animation \""+animation+"\" exists for the entity");
	play(animation)
