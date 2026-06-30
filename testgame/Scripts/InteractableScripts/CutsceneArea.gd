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
		print("133 ", Global.get(Global_var_check))
		Global.cutsceneStarted = true
		if !Global.player.is_on_floor() and !airCutscene:
			await Global.player.landed
		Global.startCutscene(dialogueFile, startingPoint, startingCutscene)
	else:
		print("134 ", Global.get(Global_var_check))
		return
