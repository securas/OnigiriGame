extends KinematicBody2D

const MAX_VEL = 100
var fsm : FSM
var vel : Vector2
var dir := 1.0
var dir_nxt := 1.0

var original_position : Vector2

func _ready():
	fsm = FSM.new( self, $states, $states/idle, false )
	fsm.anim = $anim
	original_position = global_position

func _exit_tree():
	fsm.free()

func _physics_process(delta):
	fsm.run_machine( delta )
	
	if vel.length_squared() > 0:
		if vel.x > 0:
			dir_nxt = 1
		elif vel.x < 0:
			dir_nxt = -1
	
	if dir_nxt != dir:
		dir = dir_nxt
		$rotate.scale.x = dir
	
	
func get_nearest( arr ):
	var curout = null
	var mindist = 10000000
	for a in arr:
		var dist = ( a.global_position - global_position ).length()
		if dist < mindist:
			mindist = dist
			curout = a
	return curout

func is_target_visible(targetpos) -> bool:
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray( global_position, targetpos, [ self ], 1 )
	if result.empty():
		return true
	return false
