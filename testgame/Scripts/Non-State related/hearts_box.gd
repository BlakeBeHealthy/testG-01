extends HBoxContainer

@onready var heartsUI = preload("res://Scenes/hearts_ui.tscn")
var hearts = []
const MAX_HEARTS = 3

func _ready() -> void:
	Global.playerDone.connect(_on_player_ready)
	for i in range(Global.saveData.maxHealth):
		var heart = heartsUI.instantiate()
		add_child(heart)
		hearts.append(heart)

func _on_player_ready():
	Global.player.playerHit.connect(_on_health_changed)
	Global.healthUp.connect(healthRestore)

func _on_health_changed(new_health: int) -> void:
	for i in range(hearts.size()):
		if i < new_health:
			if hearts[i].dead:
				hearts[i].revive()
		else:
			if !hearts[i].dead:
				hearts[i].die()

func healthRestore() -> void:
	_on_health_changed(Global.saveData.maxHealth)
