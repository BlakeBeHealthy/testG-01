extends HBoxContainer

@onready var heartsUI = preload("res://Scenes/hearts_ui.tscn")
var new_health

var hearts = []
func _ready() -> void:
	Global.player_ready.connect(_on_player_ready)
	for i in range(Global.saveData.maxHealth - 1):
		var heart = heartsUI.instantiate()
		add_child(heart)
		hearts.append(heart)
	print(hearts.size())

func _on_player_ready():
	Global.playerHit.connect(on_health_changed)
	
func on_health_changed(new_health):
	pass
	
func _process(delta: float) -> void:
	pass
