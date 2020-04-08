extends FSM_State



func initialize():
	anim.anim_nxt( "run_rice" )


func run( delta ):
	
	var dist = obj.original_position - obj.global_position
	var desired_vel = dist.normalized() * obj.MAX_VEL
	var force = desired_vel - obj.vel
	obj.vel += force * delta
	if dist.length() > 16:
		obj.vel = obj.vel.clamped( obj.MAX_VEL )
	elif dist.length() > 4:
		obj.vel = obj.vel.clamped( obj.MAX_VEL * dist.length() / 16 )
	else:
		fsm.state_nxt = fsm.states.eat
		obj.global_position = obj.original_position
	
	obj.vel = obj.move_and_slide( obj.vel )
