extends FSM_State

var search_area : Area2D

func initialize():
	anim.anim_nxt( "idle" )
	search_area = obj.get_node( "search" )

func run( _delta ):
	obj.vel *= 0
	
	
	# search for rice balls
	var c = search_area.get_overlapping_areas()
	if not c.empty():
		fsm.states.seek.target = weakref( obj.get_nearest( c ) )
		fsm.state_nxt = fsm.states.seek
		return
#	else:
#		var onigiris = search_area.get_overlapping_bodies()
#		var cscore = []
#		for c in onigiris:
#			if c.score > 0 and obj.is_target_visible( c.global_position ):
#				cscore.append(c)
#		if not cscore.empty():
#			fsm.states.seek.target = weakref( obj.get_nearest( cscore ) )
#			fsm.state_nxt = fsm.states.seek
