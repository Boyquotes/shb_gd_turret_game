extends Control

export var hvalue = 10
export var svalue = 0

onready var health_value = get_node("HealthValue")
onready var score_value = get_node("ScoreValue")

func _ready():
	health_value.text = String(hvalue)
	score_value.text = String(svalue)
	
func set_hud_value(arg):
	hvalue = arg
	health_value.text = String(hvalue)
	
func set_hud_score_value(arg):
	svalue = arg
	score_value.text = String(svalue)
