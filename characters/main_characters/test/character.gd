extends Node2D

@onready var tile_map = $"../TileMap"
@onready var pointer = $"../Pointer"

var is_confirmed = false
var input_delay = false
var current_tile: Vector2 = position
var target_tile: Vector2 = position

func _physics_process(_delta):
	if Input.is_action_just_pressed("enter") and is_confirmed == false:
		is_confirmed = true
		var move_animation = create_tween()
		move_animation.tween_property(self, "position", tile_map.map_to_local(target_tile), 0.5)
		await get_tree().create_timer(0.7).timeout
		is_confirmed = false


func _process(_delta):
	if is_confirmed:
		return
	
	if Input.is_action_just_released("up"):
		move(Vector2.UP)
		await get_tree().create_timer(0.7).timeout
		input_delay = false
	elif Input.is_action_just_released("down"):
		move(Vector2.DOWN)
		await get_tree().create_timer(0.7).timeout
		input_delay = false
	elif Input.is_action_just_released("left"):
		move(Vector2.LEFT)
		await get_tree().create_timer(0.7).timeout
		input_delay = false
	elif Input.is_action_just_released("right"):
		move(Vector2.RIGHT)
		await get_tree().create_timer(0.7).timeout
		input_delay = false



func move(direction: Vector2):
	if input_delay == true:
		return
	input_delay = true
	
	# Get current tile Vector2i
	current_tile = tile_map.local_to_map(position)
	# Get current target Vector2i
	target_tile = Vector2(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	# Get custom data layer from the target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)

	# Move Pointer
	if tile_data.get_custom_data("walkable") == false:
		target_tile = current_tile
		return
	else:
		pointer.global_position = tile_map.map_to_local(target_tile)
