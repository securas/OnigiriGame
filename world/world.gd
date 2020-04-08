extends Node2D

var rice_ball_count := 10
var gameover := false


var gamescore := 0
var temp_gamescore := 0

var has_rice_ball := false

func _ready():
	var _ret = Sigmgr.connect( "spawn_new_onigiri_at", self, "_on_spawn_new_onigiri", [], CONNECT_DEFERRED )
	_ret = Sigmgr.connect("new_rice_ball_available", self, "_on_new_rice_ball", [], CONNECT_DEFERRED )
	_ret = Sigmgr.connect("rice_ball_animation_finished", self, "_on_new_rice_ball_animation", [], CONNECT_DEFERRED )
	create_nori()


func _input(event):
	if not gameover:
		if event.is_action_pressed("btn_mouse"):
			#Sigmgr.emit_signal ("mouse_click_main", get_global_mouse_position() )
			var mousepos = get_global_mouse_position()
			if $walls.is_tile_here( mousepos ):
				return
			if not check_mouse_collision( mousepos ):
				return
			if not has_rice_ball: return
			
			$CanvasLayer/chopsticks.frame = 1
			has_rice_ball = false
			var r = preload( "res://rice_ball/rice_ball.tscn" ).instance()
			$walls.add_child( r )
			r.global_position = mousepos
			rice_ball_count -= 1
			update_hud()
	else:
		if event.is_action_pressed("btn_mouse"):
			$gamoverlayer/reason.hide()
			$gamoverlayer/Node2D.hide()
			Sigmgr.emit_signal("game_finished", gamescore)
			set_process_input(false)


func _physics_process(_delta):
	if temp_gamescore < gamescore:
		temp_gamescore += 1
		$CanvasLayer/hud/scorelabel.text = "%d" % [ temp_gamescore ]
	
func _process( _delta ):
	# chopsticks
	$CanvasLayer/chopsticks.position = get_local_mouse_position()


func _on_spawn_new_onigiri( pos ):
	var onigiri = preload( "res://onigiri/onigiri.tscn" ).instance()
	onigiri.position = pos
	$walls.add_child( onigiri )
	gamescore += 100


func _on_new_rice_ball( pos ):
	var frb = preload( "res://flying_rice_ball/flying_rice_ball.tscn" ).instance()
	frb.position = pos
	$CanvasLayer.add_child(frb)
	gamescore += 5
	
func _on_new_rice_ball_animation():
	$CanvasLayer/hud/riceball_counter/shake.play("shake")
	$CanvasLayer/hud/riceball_counter/shake.queue("default")
	rice_ball_count += 1
	update_hud()

func  update_hud():
	$CanvasLayer/hud/riceball_counter/riceballcountlabel.text = "%d" % [rice_ball_count]


func _on_nori_timer_timeout():
	return
#	$nori_group/nori_timer.wait_time = rand_range( 4, 9 )
#	var n = preload("res://nori/nori.tscn").instance()
#	n.position = Vector2( rand_range( 16, 320 - 16 ), rand_range( 32, 180 - 32 ) ).round()
#	$nori_group.add_child(n)



func create_nori():
	var random_position = $walls.get_random_position()
	
	print( "Creating nori at: ", random_position )
	var n = preload("res://nori/nori.tscn").instance()
	n.position = random_position
	var _ret = n.connect("tree_exited", self, "create_nori", [], CONNECT_DEFERRED )
	$walls/nori_group.add_child(n)


var gameover_reason = ""
func is_game_over() -> bool:
	var children = $walls.get_children()
	var onigiri_counter := 0
	var final_onigiri_counter := 0
	var rice_ball_counter := 0
	for c in children:
		if c is Onigiri:
			onigiri_counter += 1
		elif c is FinalOnigiri:
			final_onigiri_counter += 1
		elif c is RiceBall:
			rice_ball_counter += 1
	rice_ball_counter += rice_ball_count
	if has_rice_ball: rice_ball_counter += 1
	
	#print( "Result: ", onigiri_counter, " ", final_onigiri_counter, " ", rice_ball_counter)
	if onigiri_counter == 0:
		gameover_reason = "No more onigiris"
		return true
	if rice_ball_counter == 0 and final_onigiri_counter == 0:
		gameover_reason = "No more rice"
		return true
	
	return false




func _on_gameover_timer_timeout():
	if is_game_over():
		gameover = true
		Sigmgr.emit_signal( "gameover" )
		$gamoverlayer/reason.text = gameover_reason
		$gamoverlayer/Node2D/finalscore.text = "%d" % [ gamescore ]
		$gamoverlayer/gameoveranim.play("show")
		$gameover_timer.stop()



func check_mouse_collision( pos ):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_point( pos, 1, [], 8 + 512, true, true )
	print( result )
	if result.empty(): return true
	return false
#func is_target_visible(targetpos) -> bool:
#	var space_state = get_world_2d().direct_space_state
#	var result = space_state.intersect_ray( global_position, targetpos, [ self ], 1 )
#	if result.empty():
#		return true
#	return false


func _on_rice_bowl_pressed():
	print( "PRESSED RICE")
	if rice_ball_count > 0:
		has_rice_ball = true
		$CanvasLayer/chopsticks.frame = 0
	pass # Replace with function body.
