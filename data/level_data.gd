class_name Levels

static var Database = {
	"world_1" : {
		"name" : "World 1",
		"unlocked" : true,
		"id" : 1,
		"levels" : [
			{
				"name" : "Level 1",
				"id" : 1,
				"unlocked" : true,
				"fuel" : 120.0,
				"high_score" : 0,
			},
			{
				"name" : "Level 2",
				"id" : 2,
				"unlocked" : true,
				"fuel" : 120.0,
				"high_score" : 0,
			},
			{
				"name" : "Level 3",
				"id" : 3,
				"unlocked" : true,
				"fuel" : 120.0,
				"high_score" : 0,
			},
			{
				"name" : "Level 4",
				"id" : 4,
				"unlocked" : true,
				"fuel" : 150.0,
				"high_score" : 0,
			},
		]
	},
	"world_2" : {
		"name" : "World 2",
		"unlocked" : true,
		"id" : 2,
		"levels" : [
			{
				"name" : "Level 1",
				"id" : 1,
				"unlocked" : true,
				"fuel" : 150.0,
				"high_score" : 0,
			},
			{
				"name" : "Level 2",
				"id" : 2,
				"unlocked" : true,
				"fuel" : 150.0,
				"high_score" : 0,
			},
			{
				"name" : "Level 3",
				"id" : 3,
				"unlocked" : true,
				"fuel" : 150.0,
				"high_score" : 0,
			},
			{
				"name" : "Level 4",
				"id" : 4,
				"unlocked" : true,
				"fuel" : 150.0,
				"high_score" : 0,
			},
		]
	},
	"world_3" : {
		"name" : "World 3",
		"unlocked" : true,
		"id" : 3,
		"levels" : [
			{
				"name" : "Level 1",
				"id" : 1,
				"unlocked" : true,
				"fuel" : 150.0,
				"high_score" : 0,
			},
			{
				"name" : "Level 2",
				"id" : 2,
				"unlocked" : true,
				"fuel" : 150.0,
				"high_score" : 0,
			},
			{
				"name" : "Level 3",
				"id" : 3,
				"unlocked" : true,
				"fuel" : 150.0,
				"high_score" : 0,
			},
			{
				"name" : "Level 4",
				"id" : 4,
				"unlocked" : true,
				"fuel" : 150.0,
				"high_score" : 0,
			},
		]
	}
}

# Save level unlock status
static func save_progress():
	var save_game = FileAccess.open("user://level_progress.save", FileAccess.WRITE)
	var json_string = JSON.stringify(Database)
	save_game.store_line(json_string)
	print("Game progress saved")

# Load level unlock status
static func load_progress():
	if FileAccess.file_exists("user://level_progress.save"):
		var save_game = FileAccess.open("user://level_progress.save", FileAccess.READ)
		var json_string = save_game.get_line()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var loaded_data = json.data
			if loaded_data is Dictionary:
				Database = loaded_data
				print("Game progress loaded")
