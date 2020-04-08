extends Node
class_name FSM

var debug = false
var states = {}
var state_cur = null
var state_nxt = null
var state_lst = null
var obj : KinematicBody2D = null
# warning-ignore:unused_class_variable
var anim = null setget _set_anim


# warning-ignore:shadowed_variable
func _init( _obj, states_parent_node, initial_state, _debug = false ):
	self.obj = _obj
	self.debug = _debug
	_set_states_parent_node( states_parent_node )
	state_nxt = initial_state
	pass

func _set_anim( node ):
	anim = node
	for key in states.keys():
		states[key].anim = anim

func _set_states_parent_node( pnode ):
	if debug: print( "Found ", pnode.get_child_count(), " states" )
	if pnode.get_child_count() == 0:
		return
	var state_nodes = pnode.get_children()
	for state_node in state_nodes:
		if not state_node is FSM_State: continue
		if debug: print( "adding state: ", state_node.name )
		states[ state_node.name ] = state_node
		state_node.fsm = self
		state_node.obj = self.obj


func run_machine( delta ):
	if state_nxt != state_cur:
		if state_cur != null:
			if debug:
				print( "(", obj.get_tree().get_frame(), ") ", obj.name, ": changing from state ", state_cur.name, " to ", state_nxt.name )
			state_cur.terminate()
		elif debug:
			print( "(", obj.get_tree().get_frame(), ") ", obj.name, ": starting with state ", state_nxt.name )
		state_lst = state_cur
		state_cur = state_nxt
		state_cur.initialize()
	# run state
	state_cur.run( delta )

