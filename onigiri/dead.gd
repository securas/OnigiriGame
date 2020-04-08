extends FSM_State


func initialize():
	var do = preload( "res://onigiri/dead_onigiri.tscn" ).instance()
	do.position = obj.position
	obj.get_parent().add_child( do )
	obj.queue_free()
