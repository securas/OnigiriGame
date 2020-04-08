extends FSM_State


func initialize():
	if obj.dir_y > 0:
		anim.anim_nxt( "idle_down" )
	else:
		anim.anim_nxt( "idle_up" )

func run( _delta ):
	obj.vel *= 0
	obj.vel = obj.move_and_slide( obj.vel )
	
	
	# look at mouse
	var mouse_dir = obj.get_global_mouse_position() - obj.global_position
	if mouse_dir.length() < 96 and obj.is_target_visible(obj.get_global_mouse_position()):
		if randf() < 0.5:
			anim.anim_nxt( "jump_down" )
		if mouse_dir.x > 0:
			obj.dir_x_nxt = 1
		elif mouse_dir.x < 0:
			obj.dir_x_nxt = -1
		if mouse_dir.y > 0:
			obj.dir_y_nxt = 1
		elif mouse_dir.y < 0:
			obj.dir_y_nxt = -1
	else:
		if obj.dir_y >= 0:
			anim.anim_nxt( "idle_down" )
		else:
			anim.anim_nxt( "idle_up" )


	
