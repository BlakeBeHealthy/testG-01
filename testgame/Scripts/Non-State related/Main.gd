extends Node2D
#Eventually I plan to make this have an array of all the levelpaths and once saving is introduced,
	#the player will load the save and spawn whereever is saved last. 
	


func _ready():
	InputMap.load_from_project_settings()
	SceneM.load_level("res://Scenes/level_08.tscn")
	
