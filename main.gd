extends Node2D

var scoreboard = { \
	"players" : [ \
		"shimizu", "yui", "kimura", \
		"Hideaki", "Akanuma", "satoh" ],
	"player_scores" : [ \
		6000, 5000, 4000, 3000, 2000, 1000 ] }


var curscore := 4500

func _ready():
	randomize()
	get_tree().paused = true
	prepare_game()
	#_on_gameover()
	var _ret = Sigmgr.connect("game_finished",self,"_on_game_finished")
	$top_scores/top_scores.show()
	
	load_scoreboard()
	update_top_scores()






func prepare_game():
	$top_scores/top_scores.show()
	var w = preload( "res://world/world.tscn" ).instance()
	if $world_container.get_child_count() > 0:
		$world_container.get_child(0).queue_free()
	$world_container.add_child(w)
	

func _on_start_btn_pressed():
	prepare_game()
	$top_scores/top_scores.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_gameover():
	#get_tree().paused = true
	$new_top_score/new_top_score.show()
	$new_top_score/new_top_score/nameedit.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_nameedit_text_changed(new_text:String):
	print( new_text )
	var t = new_text.to_upper()
	var c = $new_top_score/new_top_score/nameedit.caret_position
	$new_top_score/new_top_score/nameedit.text = t
	$new_top_score/new_top_score/nameedit.caret_position = c


func _on_nameedit_text_entered(new_text):
	var t = new_text.to_upper()
#	var lowest_score_idx = get_lowest_score_position()
	var scorepos = get_score_position( curscore )
	scoreboard.player_scores.insert(scorepos, curscore)
	scoreboard.player_scores.pop_back()
	scoreboard.players.insert(scorepos, t)
	scoreboard.players.pop_back()
	$new_top_score/new_top_score/nameedit.text = ""
	$new_top_score/new_top_score.hide()
	
	update_top_scores()
	save_scoreboard()
	$top_scores/top_scores.show()


onready var scoreobjs = [ \
	$top_scores/top_scores/player_1, \
	$top_scores/top_scores/player_2, \
	$top_scores/top_scores/player_3, \
	$top_scores/top_scores/player_4, \
	$top_scores/top_scores/player_5, \
	$top_scores/top_scores/player_6 ]

func update_top_scores():
	for idx in range( scoreboard.players.size() ):
		var scorestr = "%d" % [ scoreboard.player_scores[idx] ]
		
		var dotsstr = ""
		for _n in range( scoreboard.players[idx].length(), ( 21 - scorestr.length() ) ):
			dotsstr += "."
		scoreobjs[idx].text = "%s%s%s" % [ scoreboard.players[idx], dotsstr, scorestr ]
	pass
	

func get_score_position( score ) -> int:
	var best_idx = -1
	var best_score = -1
	for idx in range( scoreboard.player_scores.size() ):
		if scoreboard.player_scores[idx] < score and scoreboard.player_scores[idx] > best_score:
			best_score = scoreboard.player_scores[idx]
			best_idx = idx
	return best_idx

func get_lowest_score_position() -> int:
	var best_idx = -1
	var best_score = 1000000000
	for idx in range( scoreboard.player_scores.size() ):
		if scoreboard.player_scores[idx] < best_score:
			best_score = scoreboard.player_scores[idx]
			best_idx = idx
	return best_idx


func _on_game_finished( gamescore):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	curscore = gamescore
	var lowest_score = scoreboard.player_scores[get_lowest_score_position()]
	if lowest_score < curscore:
		_on_gameover()
	else:
		prepare_game()

var _fname = "scoreboard.dat"
func load_scoreboard():
	var f := File.new()
	if not f.file_exists( _fname ):
		return
	var err = f.open_encrypted_with_pass( \
			_fname, File.READ, OS.get_unique_id() )
	if err != OK:
		f.close()
		return
	scoreboard = f.get_var()
	print( "Loaded Scoreboard ", scoreboard )
	f.close()

func save_scoreboard():
	var f := File.new()
	var err := f.open_encrypted_with_pass( \
			_fname, File.WRITE, OS.get_unique_id() )
	if err == OK:
		f.store_var( scoreboard )
		f.close()
		return true
	else:
		f.close()
		return false



