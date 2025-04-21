extends Node

# References
@onready var player = %Player
@onready var game_ui = %GameUi
@onready var menu_ui: CanvasLayer = %MenuUi
@onready var world: Node2D = %World2D
@onready var game_background: Node2D = %GameBackground
@onready var animation_scene_player: AnimationPlayer = %AnimationScenePlayer


# Game state
var current_level = 1
var current_world = 1
var high_score = 0
var level_complete_timer = null
var has_landed = false
var initial_player_position = Vector2.ZERO

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
	level_complete_timer = Timer.new()
	level_complete_timer.one_shot = true
	level_complete_timer.wait_time = 3.0 # Show success message for 3 seconds
	level_complete_timer.timeout.connect(_on_level_complete_timer_timeout)
	add_child(level_complete_timer)
	
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
		if player.mission_status == "OUT OF FUEL":
			_handle_out_of_fuel()
		else:
			_handle_crash()
	elif player.landed:
		if not has_landed:
			_handle_successful_landing()

# Handle player crash
func _handle_crash():
	# Show crash message via mission status
	game_ui.show_message("CRASHED!")
	
	# Wait for a moment before returning to menu
	if not level_complete_timer.is_stopped():
		return
	
	level_complete_timer.start()

# Handle out of fuel situation
func _handle_out_of_fuel():
	# Show out of fuel message via mission status
	game_ui.show_message("OUT OF FUEL!")
	
	# Wait for a moment before returning to menu
	if not level_complete_timer.is_stopped():
		return
	
	level_complete_timer.start()

# Handle successful landing
func _handle_successful_landing():
	# Show success message via mission status
	has_landed = true
	game_ui.show_message("LANDED!")
	
	# Unlock the next level
	_unlock_next_level()
	
	# Wait for a moment before returning to menu
	if not level_complete_timer.is_stopped():
		return
	
	level_complete_timer.start()

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
	
	# Reset player when starting a new level
	player.reset_player()
	player.position = initial_player_position
	has_landed = false
	
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
	
	# Reset game state for menu
	world.process_mode = Node.PROCESS_MODE_DISABLED
	menu_ui.process_mode = Node.PROCESS_MODE_INHERIT
	menu_ui.visible = true
	game_ui.visible = false  # Hide game UI when returning to menu
	
	# Update the level buttons to reflect newly unlocked levels
	menu_ui._update_level_buttons()

func _handle_world_change(world_id: int):
	var color_index = world_id - 1;
	game_background._set_gradient(color_index)
