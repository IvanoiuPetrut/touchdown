extends CanvasLayer

@onready var mission_status: Label = $Panel/VBoxContainer/MissionStatus
@onready var score: Label = $Panel/VBoxContainer/Score
@onready var high_score: Label = $Panel/VBoxContainer/HighScore

func _change_mission_end_status(value: String):
	mission_status.text = value

func _change_mission_end_score(value: String):
	# Ensure the score is displayed as an integer
	var score_value = value
	if value.is_valid_float():
		score_value = str(int(float(value)))
	score.text = "Score: " + score_value

func _change_mission_end_high_score(value: String):
	# Ensure the high score is displayed as an integer
	var high_score_value = value
	if value.is_valid_float():
		high_score_value = str(int(float(value)))
	high_score.text = "High Score: " + high_score_value
