extends Node

# References
@onready var player = %Player
@onready var game_ui = %GameUi
@onready var menu_ui: CanvasLayer = %MenuUi
@onready var world: Node2D = %World2D
@onready var game_background: Node2D = %GameBackground
@onready var animation_scene_player: AnimationPlayer = %AnimationScenePlayer
@onready var timer_finish_level: Timer = %TimerFinishLevel
@onready var level_finish: CanvasLayer = %LevelFinish

# Add GeneralEnums for player sprite tint
const GeneralEnums = preload("res://data/enums/general.gd")

# Game state
var current_level = 1
var current_world = 1
var high_score = 0
var level_complete_timer = null
var has_landed = false
var initial_player_position = Vector2.ZERO
var mission_in_progress = true

func _ready():
	player.stats_changed.connect(_update_ui)
	menu_ui.level_selected.connect(_handle_level_selection)
	menu_ui.world_changed.connect(_handle_world_change)
	initial_player_position = player.position
	has_landed = false
	world.process_mode = Node.PROCESS_MODE_DISABLED
	game_ui.visible = false  # Hide game UI initially
	game_background._set_gradient(0)
	_update_ui()
	
	# Create a timer for delayed actions after level completion
	
	# Load saved progress
	Levels.load_progress()
	menu_ui._update_planet_selector_btns()


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
		level_finish._change_mission_end_score(str(int(player.score)))
		
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
	if mission_in_progress:
		if player.crashed:
			mission_in_progress = false
			if player.mission_status == "OUT OF FUEL":
				_handle_out_of_fuel()
			else:
				_handle_crash()
		elif player.landed:
			if not has_landed:
				mission_in_progress = false
				_handle_successful_landing()

# Handle player crash
func _handle_crash():
	# Show crash message via mission status
	game_ui.show_message("CRASHED!")
	timer_finish_level.start()
	level_finish._change_mission_end_status("CRASHED")
	animation_scene_player.play("show_level_stats")

	# Wait for a moment before returning to menu
	#if not level_complete_timer.is_stopped():
		#return
	#
	#level_complete_timer.start()

# Handle out of fuel situation
func _handle_out_of_fuel():
	# Show out of fuel message via mission status
	game_ui.show_message("OUT OF FUEL!")
	level_finish._change_mission_end_status("OUT OF FUEL")
	timer_finish_level.start()
	animation_scene_player.play("show_level_stats")
	# Wait for a moment before returning to menu
	#if not level_complete_timer.is_stopped():
		#return
	#
	#level_complete_timer.start()

# Handle successful landing
func _handle_successful_landing():
	# Show success message via mission status
	has_landed = true
	game_ui.show_message("LANDED!")
	level_finish._change_mission_end_status("LANDED")
	animation_scene_player.play("show_level_stats")
	
	
	# Unlock the next level
	_unlock_next_level()
	timer_finish_level.start()
	
	# Wait for a moment before returning to menu
	#if not level_complete_timer.is_stopped():
		#return
	#
	#level_complete_timer.start()

func _change_level(worldNumber: int, levelNumber: int):
#	res://scenes/levels/world_1/level_1.tscn
	const FILE_BEGIN = "res://scenes/levels/"
	var level_path = FILE_BEGIN + "world_" + str(worldNumber) + "/level_" + str(levelNumber) + ".tscn"
	var level_scene = load(level_path)
	var newLevel = level_scene.instantiate()
	world.add_child(newLevel)
	
	# Update current level and world
	current_world = worldNumber
	current_level = levelNumber

func _destroy_current_level():
	for child in world.get_children():
		if "Level" in child.name: 
			child.queue_free()
			break

func _handle_level_selection(world_id: int, level_id: int):
	print("GameManager: ", world_id, " ", level_id)
	current_world = world_id
	current_level = level_id
	animation_scene_player.play("initiate_change_scene")
	
func _handle_level_selection_from_anim():
	_change_level(current_world, current_level)
	menu_ui.visible = false
	game_ui.visible = true  # Show game UI when starting game
	world.process_mode = Node.PROCESS_MODE_INHERIT
	menu_ui.process_mode = Node.PROCESS_MODE_DISABLED
	
	# Update the tint color for the animated texture rect
	game_ui.update_tint_color(current_world)
	
	# Update the player sprite tint
	_update_player_tint(current_world)
	
	# Get the fuel value for this level with error handling
	var level_fuel = 100.0  # Default value if not found
	var world_key = "world_" + str(current_world)
	
	# Check if the world key exists
	if Levels.Database.has(world_key):
		var levels = Levels.Database[world_key].levels
		# Check if the level index is valid
		if current_level >= 1 and current_level <= levels.size():
			var level_data = levels[current_level - 1]
			# Check if the level has a fuel property
			if level_data.has("fuel"):
				level_fuel = level_data.fuel
	
	# Reset player when starting a new level
	player.reset_player(level_fuel)
	player.position = initial_player_position
	has_landed = false
	mission_in_progress = true  # Reset mission state
	
# Unlocks the next level or world
func _unlock_next_level():
	var next_level = current_level + 1
	var next_world = current_world
	
	# Check if we need to move to the next world
	if next_level > 4:
		next_level = 1
		next_world += 1
	
	# Check if next world exists
	var world_key = "world_" + str(next_world)
	if next_world <= 3: # We have 3 worlds in total
		if next_level == 1 and next_world > current_world:
			# Unlock the next world
			Levels.Database[world_key].unlocked = true
			print("Unlocked World " + str(next_world))
		
		# Unlock the next level
		if next_level <= 4: # Each world has 4 levels
			print("Unlocking: World " + str(next_world) + " Level " + str(next_level))
			Levels.Database[world_key].levels[next_level - 1].unlocked = true
	
	print("Unlocked: World " + str(next_world) + " Level " + str(next_level))
	menu_ui._update_planet_selector_btns()
	
	# Save progress after unlocking
	Levels.save_progress()

# Timer timeout handler for level completion
func _on_level_complete_timer_timeout():
	# Return to menu
	_return_to_menu()

# Return to the level selection menu
func _return_to_menu():
	_destroy_current_level()
	print("Returning to menu")
	
	# Reset game state for menu
	world.process_mode = Node.PROCESS_MODE_DISABLED
	menu_ui.process_mode = Node.PROCESS_MODE_INHERIT
	menu_ui.visible = true
	game_ui.visible = false  # Hide game UI when returning to menu
	level_finish.visible = false
	
	# Update the level buttons to reflect newly unlocked levels
	menu_ui._update_level_buttons()

func _handle_world_change(world_id: int):
	var color_index = world_id - 1;
	game_background._set_gradient(color_index)
	game_ui.update_tint_color(world_id)
	
	# Update player sprite tint directly
	_update_player_tint(world_id)

func _on_timer_finish_level_timeout() -> void:
	#Play animations from left to right, call retrun to menu and finish animation
	animation_scene_player.play("go_back_to_level_selection")

# Helper function to update player sprite tint
func _update_player_tint(world_id: int) -> void:
	if player and player.get_node("Sprite2D") and player.get_node("Sprite2D").material:
		var color_index = world_id - 1
		var planet_colors = GeneralEnums.new().get_planet_colors(color_index)
		var tint_color = Color(planet_colors[0])
		
		# Set the shader parameter
		player.get_node("Sprite2D").material.set_shader_parameter("tint_color", tint_color)
