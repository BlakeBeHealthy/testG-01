extends Node2D
#Eventually I plan to make this have an array of all the levelpaths and once saving is introduced,
	#the player will load the save and spawn whereever is saved last. 
	


func _ready():
	Global.load_game()
	InputMap.load_from_project_settings()
	Gameplay.game_respawn()
	FadeS.fade_in()
	SceneM.load_level(Global.saveData.checkpoint_scene)
	
