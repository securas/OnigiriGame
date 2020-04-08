extends AnimationPlayer
class_name CustomAnim

func anim_cur() -> String:
	return current_animation

func anim_nxt( anim_name, restart = false ) -> void:
	if restart:
		play( anim_name )
	else:
		if current_animation != anim_name:
			play( anim_name )

func anim_queue( anim_name ) -> void:
	queue( anim_name )
