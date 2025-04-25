extends CanvasLayer

# Add this line to preload the general.gd file for the enums
const GeneralEnums = preload("res://data/enums/general.gd")

# UI Elements - all simple labels
@onready var fuel_label = $PanelContainer/MarginContainer/GridContainer/FuelLabel
@onready var score_label = $PanelContainer/MarginContainer/GridContainer/ScoreLabel
@onready var mission_time_label = $PanelContainer/MarginContainer/GridContainer/TimeLabel
@onready var altitude_label = $PanelContainer/MarginContainer/GridContainer/AltitudeLabel
@onready var horizontal_speed_label = $PanelContainer/MarginContainer/GridContainer/HorizontalSpeedLabel
@onready var vertical_speed_label = $PanelContainer/MarginContainer/GridContainer/VerticalSpeedLabel
@onready var mission_status_label = $PanelContainer/MarginContainer/GridContainer/StatusLabel
@onready var high_score_label = $PanelContainer/MarginContainer/GridContainer/HighScoreLabel

@onready var fuel_icon: Label = $PanelContainer/MarginContainer/GridContainer/FuelIcon
@onready var time_icon: Label = $PanelContainer/MarginContainer/GridContainer/TimeIcon
@onready var altitude_icon: Label = $PanelContainer/MarginContainer/GridContainer/AltitudeIcon
@onready var horizontal_speed_icon: Label = $PanelContainer/MarginContainer/GridContainer/HorizontalSpeedIcon
@onready var vertical_speed_icon: Label = $PanelContainer/MarginContainer/GridContainer/VerticalSpeedIcon
@onready var status_icon: Label = $PanelContainer/MarginContainer/GridContainer/StatusIcon
@onready var score_icon: Label = $PanelContainer/MarginContainer/GridContainer/ScoreIcon
@onready var high_score_icon: Label = $PanelContainer/MarginContainer/GridContainer/HighScoreIcon


#@onready var high_score_label = $GridContainer/HighScoreLabel
#@onready var level_label = $GridContainer/LevelLabel
@onready var animated_texture_rect: AnimatedTextureRect = $AnimatedTextureRect

# Base color for UI text
var base_color = Color("#4c4e50")
var current_label_color = base_color

# Called when the node enters the scene tree for the first time
func _ready():
	# Initialize with default world (world 1) colors
	update_tint_color(1)

# Format for time display (MM:SS.ms)
func format_time(seconds: float) -> String:
	var minutes = int(seconds / 60)
	var remaining_seconds = int(seconds) % 60
	
	return "%02d:%02d" % [minutes, remaining_seconds]

# Update fuel display
func update_fuel(value: float):
	if fuel_label:
		fuel_label.text = "%d%%" % int(value)

# Update score display
func update_score(value: int):
	if score_label:
		score_label.text = "%d" % value

# Update high score display
func update_high_score(value: int):
	if high_score_label:
		high_score_label.text = "%d" % value

# Update speed displays
func update_horizontal_speed(value: float):
	if horizontal_speed_label:
		horizontal_speed_label.text = "%.1f" % value

func update_vertical_speed(value: float):
	if vertical_speed_label:
		vertical_speed_label.text = "%.1f" % value
		
		# Optionally change color based on speed (red for dangerous)
		if value > 80:  # Near the dangerous landing velocity
			vertical_speed_label.add_theme_color_override("font_color", Color(1, 0, 0))  # Red
		else:
			vertical_speed_label.add_theme_color_override("font_color", current_label_color)

# Update altitude display
func update_altitude(value: float):
	if altitude_label:
		altitude_label.text = "%.1f" % value

# Update mission time display
func update_mission_time(value: float):
	if mission_time_label:
		mission_time_label.text = format_time(value)

# Update mission status
func update_mission_status(status: String):
	if mission_status_label:
		mission_status_label.text = status
		
		# Update color based on status
		match status:
			"IN PROGRESS":
				mission_status_label.add_theme_color_override("font_color", current_label_color)
			"LANDED":
				mission_status_label.add_theme_color_override("font_color", Color(0, 1, 0))  # Green
			"CRASHED":
				mission_status_label.add_theme_color_override("font_color", Color(1, 0, 0))  # Red
			"OUT OF FUEL":
				mission_status_label.add_theme_color_override("font_color", Color(1, 0, 0))  # Red

# Update level display
func update_level(value: int):
	#if level_label:
		#level_label.text = "%d" % value
	pass

# Show message (we'll reuse mission_status_label for this)
func show_message(text: String):
	if mission_status_label and !text.is_empty():
		mission_status_label.text = text

# Function to update the tint color of the animated texture rect based on world ID
func update_tint_color(world_id: int):
	if animated_texture_rect and animated_texture_rect.material:
		# Get the first color from the planet colors array for the given world
		var color_index = world_id - 1
		var planet_colors = GeneralEnums.new().get_planet_colors(color_index)
		var tint_color = Color(planet_colors[0])
		
		# Set the shader parameter
		animated_texture_rect.material.set_shader_parameter("tint_color", tint_color)
		
		# Update UI label colors with a contrasting color
		update_ui_label_colors(tint_color)

# Calculate a contrasting color for good readability
func get_contrast_color(color: Color) -> Color:
	# Calculate luminance using standard formula
	var luminance = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b
	
	# If the color is dark, return a light color, and vice versa
	if luminance < 0.5:
		return Color(0.9, 0.9, 0.9) # Light color for dark backgrounds
	else:
		return Color(0.1, 0.1, 0.25) # Dark blue-ish color for light backgrounds

# Calculate a complementary color for icons that's different but harmonizes with the main contrast color
func get_icon_color(main_contrast_color: Color) -> Color:
	# If we're using the light contrast color, use a darker grey for icons
	if main_contrast_color.r > 0.7:  # Likely the light color
		return Color(0.6, 0.6, 0.6)  # Darker grey but still readable on dark backgrounds
	else:
		# For dark contrast color, use a lighter grey
		return Color(0.7, 0.7, 0.7)  # Light grey for dark text on light backgrounds
		
# Update all UI labels with the new contrasting color
func update_ui_label_colors(background_color: Color):
	current_label_color = get_contrast_color(background_color)
	var icon_color = get_icon_color(current_label_color)
	
	# Update all labels with the new color
	if fuel_label:
		fuel_label.add_theme_color_override("font_color", current_label_color)
	if score_label:
		score_label.add_theme_color_override("font_color", current_label_color)
	if high_score_label:
		high_score_label.add_theme_color_override("font_color", current_label_color)
	if mission_time_label:
		mission_time_label.add_theme_color_override("font_color", current_label_color)
	if altitude_label:
		altitude_label.add_theme_color_override("font_color", current_label_color)
	if horizontal_speed_label:
		horizontal_speed_label.add_theme_color_override("font_color", current_label_color)
	if vertical_speed_label and vertical_speed_label.get_theme_color("font_color") != Color(1, 0, 0):
		vertical_speed_label.add_theme_color_override("font_color", current_label_color)
	if mission_status_label and mission_status_label.text == "IN PROGRESS":
		mission_status_label.add_theme_color_override("font_color", current_label_color)
		
	# Update all icon labels with the icon color for visual hierarchy
	if fuel_icon:
		fuel_icon.add_theme_color_override("font_color", icon_color)
	if time_icon:
		time_icon.add_theme_color_override("font_color", icon_color)
	if altitude_icon:
		altitude_icon.add_theme_color_override("font_color", icon_color)
	if horizontal_speed_icon:
		horizontal_speed_icon.add_theme_color_override("font_color", icon_color)
	if vertical_speed_icon:
		vertical_speed_icon.add_theme_color_override("font_color", icon_color)
	if status_icon:
		status_icon.add_theme_color_override("font_color", icon_color)
	if score_icon:
		score_icon.add_theme_color_override("font_color", icon_color)
	if high_score_icon:
		high_score_icon.add_theme_color_override("font_color", icon_color)

# These functions remain for compatibility with the game manager, but don't do anything
func show_restart_button(visible: bool):
	pass

func show_next_level_button(visible: bool):
	pass

func show_low_fuel_warning(visible: bool):
	pass
