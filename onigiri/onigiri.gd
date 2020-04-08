extends KinematicBody2D
class_name Onigiri

const MAX_VEL = 150.0



var fsm : FSM
var vel : Vector2
var dir_x := 1.0
var dir_x_nxt := 1.0
var dir_y := 1.0
var dir_y_nxt := 1.0
var score := 0 setget _set_score

var countdown_counter := 15

func _ready():
	fsm = FSM.new( self, $states, $states/idle, false )
	fsm.anim = $anim
	
#	var _ret = Sigmgr.connect( "mouse_click_main", self, "_on_mouse_click_main", [], CONNECT_DEFERRED )
	var _ret = Sigmgr.connect("reached_target", self, "_on_reached_target", [], CONNECT_DEFERRED )
	_ret = Sigmgr.connect("gameover", self, "_on_gameover", [], CONNECT_DEFERRED )
	_set_score(0)
	
func _exit_tree():
	fsm.free()


func _set_score( v : int ):
	print( name, ": ", score )
	score = int( clamp( v, 0, 14 ) )
	if score == 14:
		Sigmgr.emit_signal("spawn_new_onigiri_at", global_position)
		score = 0
	$score.region_rect.size.x = score
	
	if score == 0:
		$countdown.start()
		countdown_counter = 15
	else:
		$countdown.stop()
		countdown_counter = 15
		$rotate/onigiri.modulate = Color( 1, 1, 1 )

func _on_reached_target( onigiri ):
	if onigiri == self: return
	#$states/run.target_position = global_position + vel.normalized() * 5
	fsm.state_nxt = fsm.states.idle

func _physics_process(delta):
	fsm.run_machine( delta )
	
	if vel.x > 0:
		dir_x_nxt = 1
	elif vel.x < 0:
		dir_x_nxt = -1
	
	if dir_x_nxt != dir_x:
		dir_x = dir_x_nxt
		$rotate.scale.x = dir_x
	if dir_y_nxt != dir_y:
		dir_y = dir_y_nxt
	
	var rice_balls = $search_rice.get_overlapping_areas()
	var visible_balls = []
	for r in rice_balls:
		if is_target_visible( r.global_position ):
			visible_balls.append( r )
	if not visible_balls.empty():
		$states/run.target = weakref( get_nearest( rice_balls ) )
		fsm.state_nxt = fsm.states.run
	

#func _on_search_rice_area_entered( area ):
#	$states/run.target = weakref( area )
#	fsm.state_nxt = fsm.states.run

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




func _on_catch_nori_area_entered(area):
	area.queue_free()
	# turn into proper onigiri
	var fo = preload( "res://final_onigiri/final_onigiri.tscn" ).instance()
	fo.position = position
	get_parent().add_child(fo)
	queue_free()


func _on_countdown_timeout():
	countdown_counter -= 1
	if countdown_counter == 0:
		fsm.state_nxt = fsm.states.dead
	if countdown_counter < 5:
		var c = 1.0 / float( 6.0 - countdown_counter )
		$rotate/onigiri.modulate = Color( c, c, c )
		


func _on_gameover():
	fsm.state_nxt = fsm.states.dead
