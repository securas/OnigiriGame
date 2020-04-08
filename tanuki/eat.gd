extends FSM_State

var eat_timer := 0.0

func initialize():
	anim.anim_nxt( "eat" )
	eat_timer = 2.2


func run( delta ):
	eat_timer -= delta
	if eat_timer <= 0:
		fsm.state_nxt = fsm.states.idle
