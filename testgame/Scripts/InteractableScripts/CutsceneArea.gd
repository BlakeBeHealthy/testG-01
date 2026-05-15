extends Area2D
@export var Global_var_check: String
@export var dialogueFile: String
@export var startingPoint: String
@export var airCutscene: bool
@export var startingCutscene: String = "null"

func _on_area_entered(area: Area2D) -> void:
	if Global.cutsceneStarted:
		return
		
	if !Global.get(Global_var_check):
		Global.cutsceneStarted = true
		if !Global.player.is_on_floor() and !airCutscene:
			await Global.player.landed
		Global.player.control_locked = true
		if startingCutscene != "null":
			Global.ap.play(startingCutscene)
			await Global.ap.animation_finished
		Global.UI.balloon.start(load(dialogueFile), startingPoint)
		 
