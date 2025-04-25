extends CanvasLayer

@onready var mission_status: Label = $Panel/VBoxContainer/MissionStatus
@onready var score: Label = $Panel/VBoxContainer/Score
@onready var high_score: Label = $Panel/VBoxContainer/HighScore

func _change_mission_end_status(value: String):
	mission_status.text = value

func _change_mission_end_score(value: String):
	score.text = "Score: " + value

func _change_mission_end_high_score(value: String):
	high_score.text = "High Score: " + value
