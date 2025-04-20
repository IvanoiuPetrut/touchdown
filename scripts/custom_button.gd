extends Control

@onready var click_sound: AudioStreamPlayer2D = $ClickSound

func _on_pressed() -> void:
	click_sound.play()
