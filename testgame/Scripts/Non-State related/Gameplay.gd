extends Node2D

#Some meat and bones of entering doors and different scenes

var pending_entry_door := ""
var pending_entry_direction := Vector2.ZERO
@onready var level_holder: Node2D = get_node("/root/Main/Gameplay/LevelHolder")
var checkJump
var started = false
var is_respawn = false
var direction = 1

func enter_door(scene_path: String, door_name: String, dir_string: int) -> void:
	#This is what I was talking about earlier with the west, east, south and north and door name and such.
	pending_entry_door = door_name 
	pending_entry_direction = _dir_from_enum(dir_string)
	checkJump = dir_string
	direction = Global.player.direction
	#Calls the fade out function
	FadeS.fade_out()
	await get_tree().create_timer(1).timeout
	#Loads the next scene with SceneManager.gd
	SceneM.load_level(scene_path)
	
func on_level_loaded(level: Node) -> void:
	#Declares player with global, this happens a lot
	var player = Global.player
	
	if is_respawn:
		player.global_position = Global.saveData.checkpoint_pos
		is_respawn = false
	else:
		var spawn: Node2D = level.get_node_or_null(pending_entry_door)
		if spawn:
			player.global_position = spawn.global_position - pending_entry_direction * 100
			if checkJump== 1:
				player.enter_from_transition(pending_entry_direction)
				
	Global.player.flip_direction(direction)
	FadeS.fade_in()
	
func _dir_from_enum(dir: int) -> Vector2:
	match dir:
		0 : return Vector2.UP
		1 : return Vector2.DOWN
		2 : return Vector2.RIGHT
		3 : return Vector2.LEFT
	return Vector2.ZERO

func game_respawn() -> void:
	is_respawn = true
