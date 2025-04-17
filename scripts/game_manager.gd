extends Node

# References
@onready var player = %Player
@onready var game_ui = %GameUi
@onready var menu_ui: CanvasLayer = %MenuUi
@onready var world: Node2D = %World2D


# Game state
var current_level = 1
var current_world = 1
var high_score = 0

func _ready():
	player.stats_changed.connect(_update_ui)
	menu_ui.level_selected.connect(_handle_level_selection)
	world.process_mode = Node.PROCESS_MODE_DISABLED
	_update_ui()

func _process(delta):
	# Update UI elements that need constant updating (like mission time)
	if player and not (player.landed or player.crashed):
		_update_time_display()
	
	# Check game state
	_check_game_state()

# Update all UI elements based on player stats
func _update_ui():
	if player and game_ui:
		# Update fuel display
		game_ui.update_fuel(player.fuel)
		
		# Update speed displays
		game_ui.update_horizontal_speed(player.horizontal_speed)
		game_ui.update_vertical_speed(player.vertical_speed)
		
		# Update altitude
		game_ui.update_altitude(player.altitude)
		
		# Update score
		game_ui.update_score(player.score)
		
		# Update mission status
		game_ui.update_mission_status(player.mission_status)
		
		# Update high score if needed
		if player.score > high_score:
			high_score = player.score
			game_ui.update_high_score(high_score)
		
		# Update level
		game_ui.update_level(current_level)
		
		# Update time display
		_update_time_display()

# Update just the time display (called frequently)
func _update_time_display():
	if game_ui:
		game_ui.update_mission_time(player.mission_time)

# Check the current game state and update UI
func _check_game_state():
	if player.crashed:
		_handle_crash()
	elif player.landed:
		_handle_successful_landing()

# Handle player crash
func _handle_crash():
	# Show crash message via mission status
	game_ui.show_message("CRASHED!")

# Handle successful landing
func _handle_successful_landing():
	# Show success message via mission status
	game_ui.show_message("SUCCESSFUL LANDING!")

func _change_level(worldNumber: int, levelNumber: int):
#	res://scenes/levels/world_1/level_1.tscn
	const FILE_BEGIN = "res://scenes/levels/"
	var level_path = FILE_BEGIN + "world_" + str(worldNumber) + "/level_" + str(levelNumber) + ".tscn"
	var level_scene = load(level_path)
	var newLevel = level_scene.instantiate()
	world.add_child(newLevel)

func _destroy_current_level():
	for child in world.get_children():
		if "Level" in child.name: 
			child.queue_free()
			break

func _handle_level_selection(world_id: int, level_id: int):
	print("GameManager: ", world_id, " ", level_id)
	_change_level(world_id, level_id)
	menu_ui.visible = false
	world.process_mode = Node.PROCESS_MODE_INHERIT
	menu_ui.process_mode = Node.PROCESS_MODE_DISABLED
