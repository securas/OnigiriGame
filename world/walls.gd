extends TileMap


func get_random_position():
	for _attemp in range( 10000 ):
		var rpos = Vector2( rand_range( 16, 320 - 16 ), rand_range( 32, 180 - 32 ) ).round()
		var mappos = world_to_map( rpos )
		if get_cellv( mappos ) != -1:
			continue
		if get_cellv( mappos + Vector2( 1, 0 ) ) != -1:
			continue
		if get_cellv( mappos + Vector2( -1, 0 ) ) != -1:
			continue
		if get_cellv( mappos + Vector2( 0, 1 ) ) != -1:
			continue
		if get_cellv( mappos + Vector2( 0, -1 ) ) != -1:
			continue
		return rpos
# warning-ignore:unreachable_code
	return Vector2.ZERO


func is_tile_here( pos ) -> bool:
	if get_cellv( world_to_map( pos ) ) != -1:
		return true
	return false
