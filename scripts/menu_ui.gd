extends CanvasLayer

# Add this line to preload the general.gd file for the enums
const GeneralEnums = preload("res://data/enums/general.gd")

@onready var planet_1: AnimatedTextureRect = %Planet1
@onready var planet_2: AnimatedTextureRect = %Planet2
@onready var planet_3: AnimatedTextureRect = %Planet3

@onready var btn_previous_planet: Button = %ButtonPreviousPlanet
@onready var btn_next_planet: Button = %ButtonNextPlanet

@onready var panel_world_selector: PanelContainer = %PanelWorldSelector
@onready var panel_level_selector: PanelContainer = %PanelLevelSelector

# Level selector panel references
@onready var panel_world_1: Panel = %PanelWorld1
@onready var panel_world_2: Panel = %PanelWorld2
@onready var panel_world_3: Panel = %PanelWorld3

# Level buttons references
# World 1 level buttons
@onready var world1_btn_l1: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld1/BtnL1
@onready var world1_btn_l2: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld1/BtnL2
@onready var world1_btn_l3: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld1/BtnL3
@onready var world1_btn_l4: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld1/BtnL4

# World 2 level buttons
@onready var world2_btn_l1: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld2/BtnL1
@onready var world2_btn_l2: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld2/BtnL2
@onready var world2_btn_l3: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld2/BtnL3
@onready var world2_btn_l4: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld2/BtnL4

# World 3 level buttons
@onready var world3_btn_l1: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld3/BtnL1
@onready var world3_btn_l2: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld3/BtnL2
@onready var world3_btn_l3: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld3/BtnL3
@onready var world3_btn_l4: Button = $PanelLevelSelector/VBoxLevelSelector/PanelWorld3/BtnL4

@onready var btn_land: Button = %ButtonLand

@onready var main_menu_background: TextureRect = $MainMenuBackground

@onready var selected_level: Label = $CurrentLevelPanel/VBoxContainer/SelectedLevel
@onready var high_score_icon: Label = $CurrentLevelPanel/VBoxContainer/HighScoreIcon
@onready var high_score_label: Label = $CurrentLevelPanel/VBoxContainer/HighScoreLabel
@onready var current_level_panel: Panel = $CurrentLevelPanel

@onready var new_world_label: Label = $PanelWorldSelector/VBoxContainer/MarginContainer/VBoxContainer/NewWorldLabel

# Signal for level selection
signal level_selected(world_id: int, level_id: int)
signal world_changed(world_id: int)

var current_planet_id : int = 1
var selected_level_id : int = 0  # Change to 0 to indicate no selection initially


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_make_planets_invisible()
	_make_planet_visible(current_planet_id)
	_update_planet_selector_btns()
	_connect_level_buttons()
	_update_level_buttons()
	_toggle_panel_world_selector(true)
	_toggle_panel_level_selector(false)
	current_level_panel.visible = false
	_setup_background_shader()
	
	# Initialize UI elements visibility
	selected_level.text = "Select level"
	high_score_icon.visible = false
	high_score_label.visible = false
	btn_land.disabled = true
	new_world_label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _make_planet_visible(id: int):
	match id:
		1:
			if(Levels.Database["world_1"].unlocked):
				planet_1.visible = true
		2:
			if(Levels.Database["world_2"].unlocked):
				planet_2.visible = true
		3:
			if(Levels.Database["world_3"].unlocked):
				planet_3.visible = true
	
func _make_planets_invisible():
		planet_1.visible = false
		planet_2.visible = false
		planet_3.visible = false

func _update_planet_selector_btns():
	# Check if there's a previous planet available
	if current_planet_id > 1:
		btn_previous_planet.disabled = false
	else:
		btn_previous_planet.disabled = true
	
	# Check if there's a next planet available AND if it's unlocked
	if current_planet_id < 3 and Levels.Database["world_" + str(current_planet_id + 1)].unlocked:
		btn_next_planet.disabled = false
	else:
		btn_next_planet.disabled = true

func _toggle_panel_level_selector(should_show: bool):
	if should_show:
		panel_level_selector.visible = true
	else:
		panel_level_selector.visible = false

func _toggle_panel_world_selector(should_show: bool):
	if should_show:
		panel_world_selector.visible = true
	else:
		panel_world_selector.visible = false

func _on_button_deploy_pressed() -> void:
	_update_level_buttons() # Update button states in case there were changes
	_show_correct_world_panel() # Show the panel for current planet
	_toggle_panel_world_selector(false)
	_toggle_panel_level_selector(true)
	current_level_panel.visible = true
	
	# Reset selection UI when entering level selection
	selected_level.text = "Select a level"
	high_score_icon.visible = false
	high_score_label.visible = false
	btn_land.disabled = true
	selected_level_id = 0

# Connect signals for all level buttons
func _connect_level_buttons() -> void:
	# World 1 buttons
	world1_btn_l1.pressed.connect(func(): _on_level_button_pressed(1, 1))
	world1_btn_l2.pressed.connect(func(): _on_level_button_pressed(1, 2))
	world1_btn_l3.pressed.connect(func(): _on_level_button_pressed(1, 3))
	world1_btn_l4.pressed.connect(func(): _on_level_button_pressed(1, 4))
	
	# World 2 buttons
	world2_btn_l1.pressed.connect(func(): _on_level_button_pressed(2, 1))
	world2_btn_l2.pressed.connect(func(): _on_level_button_pressed(2, 2))
	world2_btn_l3.pressed.connect(func(): _on_level_button_pressed(2, 3))
	world2_btn_l4.pressed.connect(func(): _on_level_button_pressed(2, 4))
	
	# World 3 buttons
	world3_btn_l1.pressed.connect(func(): _on_level_button_pressed(3, 1))
	world3_btn_l2.pressed.connect(func(): _on_level_button_pressed(3, 2))
	world3_btn_l3.pressed.connect(func(): _on_level_button_pressed(3, 3))
	world3_btn_l4.pressed.connect(func(): _on_level_button_pressed(3, 4))
	
	# Connect land button
	btn_land.pressed.connect(_on_land_button_pressed)

# Update all level buttons based on their unlock status
func _update_level_buttons() -> void:
	# World 1 buttons
	world1_btn_l1.disabled = !Levels.Database["world_1"].levels[0].unlocked
	world1_btn_l2.disabled = !Levels.Database["world_1"].levels[1].unlocked
	world1_btn_l3.disabled = !Levels.Database["world_1"].levels[2].unlocked
	world1_btn_l4.disabled = !Levels.Database["world_1"].levels[3].unlocked
	
	# World 2 buttons
	world2_btn_l1.disabled = !Levels.Database["world_2"].levels[0].unlocked
	world2_btn_l2.disabled = !Levels.Database["world_2"].levels[1].unlocked
	world2_btn_l3.disabled = !Levels.Database["world_2"].levels[2].unlocked
	world2_btn_l4.disabled = !Levels.Database["world_2"].levels[3].unlocked
	
	# World 3 buttons
	world3_btn_l1.disabled = !Levels.Database["world_3"].levels[0].unlocked
	world3_btn_l2.disabled = !Levels.Database["world_3"].levels[1].unlocked
	world3_btn_l3.disabled = !Levels.Database["world_3"].levels[2].unlocked
	world3_btn_l4.disabled = !Levels.Database["world_3"].levels[3].unlocked

# Show correct world panel based on current planet
func _show_correct_world_panel() -> void:
	panel_world_1.visible = false
	panel_world_2.visible = false
	panel_world_3.visible = false
	
	match current_planet_id:
		1:
			panel_world_1.visible = true
		2:
			panel_world_2.visible = true
		3:
			panel_world_3.visible = true

# Handle level button pressed event
func _on_level_button_pressed(world_id: int, level_id: int) -> void:
	selected_level_id = level_id
	print(selected_level_id)
	
	# Update UI elements for selected level
	selected_level.text = "Level " + str(level_id)
	
	# Show high score for the selected level
	var world_key = "world_" + str(current_planet_id)
	if Levels.Database.has(world_key):
		var level_index = level_id - 1
		if level_index >= 0 and level_index < Levels.Database[world_key].levels.size():
			var high_score = Levels.Database[world_key].levels[level_index].high_score
			high_score_label.text = str(high_score)
			high_score_icon.visible = true
			high_score_label.visible = true
			
	# Enable the land button since a level is selected
	btn_land.disabled = false

# Handles the pressed event on the Land button
func _on_land_button_pressed() -> void:
	# This will select the current world's first level (or you can customize this)
	if current_planet_id && selected_level_id:
		print("World: ", current_planet_id)
		print("Planet: ", selected_level_id)
		emit_signal("level_selected", current_planet_id, selected_level_id)
		# _toggle_panel_level_selector(false)
		# _toggle_panel_world_selector(true)


func _on_button_close_level_select_pressed() -> void:
	_toggle_panel_world_selector(true)
	_toggle_panel_level_selector(false)
	current_level_panel.visible = false
	
	# Reset selection when closing level selection
	selected_level_id = 0
	selected_level.text = "Select a level"
	high_score_icon.visible = false
	high_score_label.visible = false
	btn_land.disabled = true


func _on_button_next_planet_pressed() -> void:
	if current_planet_id < 3 and Levels.Database["world_" + str(current_planet_id + 1)].unlocked:
		current_planet_id += 1
		_make_planets_invisible()
		_make_planet_visible(current_planet_id)
		_update_planet_selector_btns()
		_update_level_buttons() # Update level buttons for new planet
		# Update background gradient with new planet colors
		emit_signal("world_changed", current_planet_id)
		set_background_gradient(current_planet_id - 1)
		
		# Reset level selection when changing planets
		selected_level_id = 0
		selected_level.text = "Select a level"
		high_score_icon.visible = false
		high_score_label.visible = false
		btn_land.disabled = true


func _on_button_previous_planet_pressed() -> void:
	if current_planet_id > 1:
		current_planet_id -= 1
		_make_planets_invisible()
		_make_planet_visible(current_planet_id)
		_update_planet_selector_btns()
		_update_level_buttons() # Update level buttons for new planet
		# Update background gradient with new planet colors
		emit_signal("world_changed", current_planet_id)
		set_background_gradient(current_planet_id - 1)
		
		# Reset level selection when changing planets
		selected_level_id = 0
		selected_level.text = "Select a level"
		high_score_icon.visible = false
		high_score_label.visible = false
		btn_land.disabled = true

# Sets up the background shader with custom colors
func _setup_background_shader() -> void:
	if main_menu_background and main_menu_background.material:
		# Get colors from the enum based on current planet
		var planet_colors = GeneralEnums.new().get_planet_colors(current_planet_id - 1)  # Adjust index to match enum
		main_menu_background.material.set_shader_parameter("first_color", Color(planet_colors[0]))
		main_menu_background.material.set_shader_parameter("second_color", Color(planet_colors[1]))

# You can also create a method to change colors dynamically
func set_background_gradient(planet_type: int) -> void:
	if main_menu_background and main_menu_background.material:
		var planet_colors = GeneralEnums.new().get_planet_colors(planet_type)
		main_menu_background.material.set_shader_parameter("first_color", Color(planet_colors[0]))
		main_menu_background.material.set_shader_parameter("second_color", Color(planet_colors[1]))

# This function will be called from the game_manager when a new world is unlocked
func show_new_world_notification():
	new_world_label.visible = true

# Update to handle level selection from the GameManager
func _handle_level_selection_from_game_manager():
	# Hide the new world label after playing any level
	new_world_label.visible = false

# Also connect to the signal for returning to menu from game
func _on_return_to_menu():
	# Hide the new world label when returning to menu
	new_world_label.visible = false
