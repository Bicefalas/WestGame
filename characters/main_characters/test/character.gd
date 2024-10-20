extends Node2D

@onready var tile_map = $"../TileMap"
@onready var pointer = $"../Pointer"
@onready var steps = $"Camera2D/PrincipalHUD/MainResources/Steps"
@onready var turn = $"Camera2D/PrincipalHUD/MainResources/TurnTracker"

var current_tile: Vector2 = position
var target_tile: Vector2 = position
var input_block_delay: bool = false

func _unhandled_input(event):
	if steps.steps <= 0 or input_block_delay == true:
		return

	input_block_delay = true

	if Input.is_action_just_released("up"):
		move(Vector2.UP)
	elif Input.is_action_just_released("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_released("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_released("right"):
		move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("enter"):
		var move_animation = create_tween()
		move_animation.tween_property(self, "position", tile_map.map_to_local(target_tile), 0.5)
		steps.substract_steps()
		if steps.steps <= 0:
			turn.add_turn()
	if input_block_delay == true:
		await  get_tree().create_timer(0.1).timeout
		input_block_delay = false

func move(direction: Vector2):
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
