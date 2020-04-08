extends FSM_State

var target = null
var direction_timer : float

func initialize():
	direction_timer = 0.0
	if obj.dir_y > 0:
		anim.anim_nxt( "run_down" )
	else:
		anim.anim_nxt( "run_up" )

func run( delta ):
	if target == null or target.get_ref() == null:
		fsm.state_nxt = fsm.states.idle
		return
	if target.get_ref().taken:
		fsm.state_nxt = fsm.states.idle
		return
		
	var dist = target.get_ref().global_position - obj.global_position
	var desired_vel = dist.normalized() * obj.MAX_VEL
	var force = desired_vel - obj.vel
	obj.vel += force * delta
	if dist.length() > 32:
		obj.vel = obj.vel.clamped( obj.MAX_VEL )
	elif dist.length() > 4:
		obj.vel = obj.vel.clamped( obj.MAX_VEL * dist.length() / 32 )
	else:
		Sigmgr.emit_signal( "reached_target", self )
		target.get_ref().taken = true
		fsm.state_nxt = fsm.states.idle
		target.get_ref().queue_free()
		obj.score += 5
	obj.vel = obj.move_and_slide( obj.vel )
	
	direction_timer -= delta
	if direction_timer <= 0:
		direction_timer = 0.1
		if obj.vel.y > 0:
			obj.dir_y_nxt = 1
		elif obj.vel.y < 0:
			obj.dir_y_nxt = -1
	
#
#	if obj.dir_y_nxt != obj.dir_y:
#		direction_timer = 0.1
#		obj.dir_y = obj.dir_y_nxt
	if obj.dir_y > 0:
		anim.anim_nxt( "run_down" )
	else:
		anim.anim_nxt( "run_up" )
