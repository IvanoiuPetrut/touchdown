extends CanvasLayer

@onready var mission_status: Label = $Panel/VBoxContainer/MissionStatus
@onready var score: Label = $Panel/VBoxContainer/Score

func _change_mission_end_status(value: String):
	mission_status.text = value

func _change_mission_end_score(value: String):
	score.text = "Score: " + value
