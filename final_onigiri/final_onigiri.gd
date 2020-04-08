extends StaticBody2D
class_name FinalOnigiri

var counter = 10

func _ready():
	var _ret = Sigmgr.connect("gameover", self, "_on_gameover", [], CONNECT_DEFERRED )

func _on_Timer_timeout():
	#print( "creating new rice ball")
	Sigmgr.emit_signal("new_rice_ball_available", position )
	counter -= 1
	if counter == 0:
		_on_gameover()
	

func _on_gameover():
	var do = preload( "res://onigiri/dead_onigiri.tscn" ).instance()
	do.position = position
	get_parent().add_child( do )
	queue_free()
