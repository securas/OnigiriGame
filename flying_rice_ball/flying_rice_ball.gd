extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$tw.interpolate_property( self, \
		'position', position, position + Vector2( 0, -16 ), \
		0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0 )
	$tw.interpolate_property( self, \
		'position', position + Vector2( 0, -16 ), \
		Vector2( 163, 85 ), \
		1, Tween.TRANS_BACK, Tween.EASE_IN, 0.5 )
	$tw.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_tw_tween_all_completed():
#	print("HELLO")
#	$particles.emitting = true
#
#


func _on_Timer_timeout():
	queue_free()


func _on_tw_tween_completed(_object, _key):
	pass
	


func _on_tw_tween_all_completed():
	$particles.emitting = true
	$Sprite.hide()
	$Timer.start()
	Sigmgr.emit_signal("rice_ball_animation_finished")
