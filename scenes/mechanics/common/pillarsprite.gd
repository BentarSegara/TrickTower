extends Node2D

@onready var tilemap: TileMap = $TileMap   # pastikan ini TileMap yang berisi pattern

func _ready():
	# 1. Ambil rect tile yang terpakai
	var rect = tilemap.get_used_rect()
	var cell = tilemap.tile_set.tile_size
	print("used_rect: ", rect)

	var width  = max(1, int(rect.size.x * cell.x))
	var height = max(1, int(rect.size.y * cell.y))
	print("export size: ", width, "x", height)

	# 2. SubViewport untuk render
	var vp := SubViewport.new()
	vp.disable_3d = true
	vp.size = Vector2i(width, height)
	vp.transparent_bg = false  # biar kelihatan (background jadi solid)
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(vp)

	# 3. Root 2D di dalam viewport
	var root := Node2D.new()
	vp.add_child(root)

	# 4. Duplikasi TileMap ke dalam viewport
	var cloned := tilemap.duplicate() as TileMap
	root.add_child(cloned)

	# Geser supaya tile pertama pas di (0, 0)
	cloned.position = -Vector2(rect.position.x * cell.x, rect.position.y * cell.y)

	# 5. Tunggu beberapa frame supaya viewport sempat render
	await get_tree().process_frame
	await get_tree().process_frame

	# 6. Ambil image dari viewport dan simpan ke PNG
	var img := vp.get_texture().get_image()
	var err := img.save_png("user://tile_export.png")
	print("save_png err: ", err)
	print("DONE -> user://tile_export.png")
