extends HBoxContainer

@onready var heartsUI = preload("res://Scenes/hearts_ui.tscn")
var hearts = []
func _ready() -> void:
	Global.playerDone.connect(_on_player_ready)
	for i in range(Global.saveData.maxHealth):
		var heart = heartsUI.instantiate()
		add_child(heart)
		hearts.append(heart)

func _on_player_ready():
	Global.player.playerHit.connect(on_health_changed)
	
func on_health_changed(new_health):
	print("getting health")
	if new_health == 0:
		print(0)
		hearts[0].die()
	else:
		for i in range(hearts.size()):
			if (new_health - 1) < i and !hearts[i].dead:
				print(new_health)
				hearts[i].die()
