extends FSM_State

var target : WeakRef

func initialize():
	anim.anim_nxt( "run" )


func run( delta ):
	if target == null or target.get_ref() == null:
		fsm.state_nxt = fsm.states.back
		return
	if not obj.is_target_visible( target.get_ref().global_position ):
		fsm.state_nxt = fsm.states.back
	
	var dist = target.get_ref().global_position - obj.global_position
	var desired_vel = dist.normalized() * obj.MAX_VEL
	var force = desired_vel - obj.vel
	obj.vel += force * delta
	if dist.length() > 16:
		obj.vel = obj.vel.clamped( obj.MAX_VEL )
	elif dist.length() > 4:
		obj.vel = obj.vel.clamped( obj.MAX_VEL * dist.length() / 16 )
	else:
		fsm.state_nxt = fsm.states.back_rice
		if target.get_ref() is Area2D:
			target.get_ref().queue_free()
		else:
			target.get_ref().score -= 5
		
	obj.vel = obj.move_and_slide( obj.vel )
	
	
