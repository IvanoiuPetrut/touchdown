extends CanvasLayer

# UI Elements - all simple labels
@onready var fuel_label = $GridContainer/FuelLabel
@onready var score_label = $GridContainer/ScoreLabel
@onready var mission_time_label = $GridContainer/MissionTimeLabel
@onready var altitude_label = $GridContainer/AltitudeLabel
@onready var horizontal_speed_label = $GridContainer/HorizontalSpeedLabel
@onready var vertical_speed_label = $GridContainer/VerticalSpeedLabel
@onready var mission_status_label = $GridContainer/MissionStatusLabel
#@onready var high_score_label = $GridContainer/HighScoreLabel
#@onready var level_label = $GridContainer/LevelLabel

# Format for time display (MM:SS.ms)
func format_time(seconds: float) -> String:
	var minutes = int(seconds / 60)
	var remaining_seconds = int(seconds) % 60
	var milliseconds = int((seconds - int(seconds)) * 100)
	
	return "%02d:%02d.%02d" % [minutes, remaining_seconds, milliseconds]

# Update fuel display
func update_fuel(value: float):
	if fuel_label:
		fuel_label.text = "FUEL: %d%%" % int(value)

# Update score display
func update_score(value: int):
	if score_label:
		score_label.text = "SCORE: %d" % value

# Update high score display
func update_high_score(value: int):
	#if high_score_label:
		#high_score_label.text = "HIGH SCORE: %d" % value
	pass

# Update speed displays
func update_horizontal_speed(value: float):
	if horizontal_speed_label:
		horizontal_speed_label.text = "HORIZONTAL SPEED: %.1f" % value

func update_vertical_speed(value: float):
	if vertical_speed_label:
		vertical_speed_label.text = "VERTICAL SPEED: %.1f" % value
		
		# Optionally change color based on speed (red for dangerous)
		if value > 80:  # Near the dangerous landing velocity
			vertical_speed_label.add_theme_color_override("font_color", Color(1, 0, 0))  # Red
		else:
			vertical_speed_label.add_theme_color_override("font_color", Color(1, 1, 1))  # White

# Update altitude display
func update_altitude(value: float):
	if altitude_label:
		altitude_label.text = "ALTITUDE: %.1f" % value

# Update mission time display
func update_mission_time(value: float):
	if mission_time_label:
		mission_time_label.text = "TIME: %s" % format_time(value)

# Update mission status
func update_mission_status(status: String):
	if mission_status_label:
		mission_status_label.text = "STATUS: %s" % status
		
		# Update color based on status
		match status:
			"IN PROGRESS":
				mission_status_label.add_theme_color_override("font_color", Color(1, 1, 1))  # White
			"LANDED":
				mission_status_label.add_theme_color_override("font_color", Color(0, 1, 0))  # Green
			"CRASHED":
				mission_status_label.add_theme_color_override("font_color", Color(1, 0, 0))  # Red

# Update level display
func update_level(value: int):
	#if level_label:
		#level_label.text = "LEVEL: %d" % value
	pass

# Show message (we'll reuse mission_status_label for this)
func show_message(text: String):
	if mission_status_label and !text.is_empty():
		mission_status_label.text = text

# These functions remain for compatibility with the game manager, but don't do anything
func show_restart_button(visible: bool):
	pass

func show_next_level_button(visible: bool):
	pass

func show_low_fuel_warning(visible: bool):
	pass
